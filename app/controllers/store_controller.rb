class StoreController < ApplicationController
  def add_to_cart
    # FIXME: Using a hack until I can sort out what is going on
    # The following code should look like this
    # cart.products << product
    # and it should just end up updating products and setting the cart_id for the product concerned
    # instead it does something funny with the versioning table
    # it would seem this behaviour is caused by something added to the model with acts_as_content_block
    cart = Cart.current_cart(session)
    if(!cart)
      # This is the first time the user has clicked on "Add to Cart" so create a cart for them
      cart = Cart.create!
      session[:cart_id] = cart.id
    end
    ActiveRecord::Base.connection.execute('UPDATE products SET cart_id=' + cart.id.to_s + ' WHERE id=' + params["product"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/shop'
  end

  def remove_from_cart
    # FIXME: Using a hack until I can sort out what is going on
    # Situation similar to the problem in add_to_cart, see comment there for details
    ActiveRecord::Base.connection.execute('UPDATE products SET cart_id = null WHERE id = ' + params["product"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/shop'
  end
end
