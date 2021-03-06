class Cart < ActiveRecord::Base
  has_many :products
  has_many :line_items
  has_one :order

  attr_reader :items
  attr_reader :total_price
  
  def add_product(product)
    @items << LineItem.for_product(product)
    @total_price += product.price
  end
  
  def total_price
    total = 0
    line_items.each do |item|
      price = item.unit_price * item.quantity
      total += price
    end
    "%05.2f" % ((total * 100).round / 100)
  end

  def total_price_in_cents
    (total_price * 100).to_i
  end

  def empty!
    @items = []
    @total_price = 0
		self.order = nil
  end

  # Returns the current cart if the user has one or nil if they don't have a cart yet
  def self.current_cart(session)
    if(session[:cart_id] && Cart.exists?(session[:cart_id]))
      cart = Cart.find(session[:cart_id])

      # Throw away this cart because the user should not be adding products to a purchased cart
      if(cart.purchased_at)
        cart = nil
        session[:cart_id] = cart
      end
    else
      # Don't create a cart for a visitor if they don't have a cart_id
      # The cart will be created the first time they click on an "Add to Cart" button
      cart = nil
    end
    cart
  end

  def google_checkout_cart_xml cart_id
    front_end = Google4R::Checkout::Frontend.new(GOOGLE_CHECKOUT_CONFIGURATION)
    front_end.tax_table_factory = GoogleCheckoutTaxTableFactory.new

    if front_end
      checkout_command = front_end.create_checkout_command
      # Adding an item to shopping cart
      products.each do |product|
        checkout_command.shopping_cart.create_item do |item|
          item.name = product.product_type.name
          item.description = product.summary_description
          item.unit_price = Money.new(100 * product.selling_price)
          item.quantity = 1 # Products are unique so there will only ever be a single product
        end
      end
    end
    # No order is created yet but use the cart to track this google order
    # Anything put in the private data hash will be available in the NewOrderNotification
    checkout_command.shopping_cart.private_data = { :cart_id => cart_id }
    # FIXME: Make the configurable by the client
    # This url is shown on the first page the client sees
    checkout_command.edit_cart_url = 'http://192.168.56.64:3000/products/products'
    # This url is displayed for "Return to ..." after the client clicks "Place Order"
    # FIXME: Do this the rails way
    checkout_command.continue_shopping_url = 'http://192.168.56.64:3000/orders/new?pp=gc'# new_order_url + '?pp=gc'

    #TODO Add shipping method stuff
    checkout_command.create_shipping_method(Google4R::Checkout::FlatRateShipping) do |shipping_method|
      shipping_method.name = "Standard"
      shipping_method.price = Money.new(100 * 10) # Just put $10 for now
      shipping_method.create_allowed_area(Google4R::Checkout::WorldArea) do |area|
        # FIXME: Restrict the shipping to certain parts of the world
      end
    end
    checkout_command.to_xml
  end
end
