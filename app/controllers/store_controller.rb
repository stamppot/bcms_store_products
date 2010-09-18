class StoreController < ApplicationController
  def add_to_cart
    # FIXME: Using a hack until I can sort out what is going on
    # The following code should look like this
    # cart.products << product
    # and it should just end up updating products and setting the cart_id for the product concerned
    # instead it does something funny with the versioning table
    # it would seem this behaviour is caused by something added to the model with acts_as_content_block

    # product = Product.find(params["params"]["id"])
    # @cart = Cart.current_cart(session)
    # @cart.add_product(product)
    # redirect_to '/shop' and return
    cart = Cart.current_cart(session)
    if(!cart)
      # This is the first time the user has clicked on "Add to Cart" so create a cart for them
      cart = Cart.create!
      session[:cart_id] = cart.id
    end

    product = Product.find params["product"]["id"]
    # increase quantity
    quantity = params["product"]["quantity"].to_i
    quantity = 1 if quantity == 0
    if line_item = cart.line_items.detect { |item| item.product_id == product.id }
      line_item.quantity += quantity
    else
      line_item = LineItem.for_product(product, quantity)
      cart.line_items << line_item
    end
    line_item.save
    @total_price += line_item.unit_price
    # ActiveRecord::Base.connection.execute('UPDATE products SET cart_id=' + cart.id.to_s + ' WHERE id=' + params["product"]["id"].to_s)
    # 
    # # FIXME: Use the real return path
    redirect_to '/shop'
  rescue
    flash[:notice] = "Produktet findes ikke."
    redirect_to '/shop' and return
  end

  def empty_cart
    @cart = Cart.current_cart(session)
    @cart.empty!
    flash[:notice] = 'Din indkøbskurv er tømt'
    redirect_to '/shop'
  end
  
  def remove_from_cart
    # get line_item containing product, remove one unit
    cart = Cart.current_cart(session)
    remove_item = cart.line_items.detect { |item| item.product_id.to_s == params["product"]["id"] }
    if remove_item.quantity == 1
      remove_item.destroy
    else
      remove_item.quantity -= 1
      remove_item.save
    end
    
    # ActiveRecord::Base.connection.execute('UPDATE products SET cart_id = null WHERE id = ' + params["product"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/shop'
  end
  
  # def checkout
  #   @cart = Cart.current_cart(session)
  #   @items = @cart.line_items
  #   if @items.empty?
  #     flash[:notice] = "Din indkøbskurv er tom"
  #     redirect_to '/shop'
  #   else
  #     @order = Order.new
  #   end    
  # end
  
end
