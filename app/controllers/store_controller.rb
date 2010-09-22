class StoreController < ApplicationController
	def add_to_cart
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
		flash[:notice] = "#{product.name} er puttet i indkøbskurven."
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
                   
  def shipping
	end
	
	def checkout
		@page_title = "Sendes til"
		@cart = Cart.current_cart(session)
		return unless @cart
		@items = @cart.line_items
		if @items.empty?
			flash[:notice] = "Din indkøbskurv er tom"
			redirect_to '/shop'
		else
			@order = Order.new
			@order.line_items = @cart.line_items
		end    
	end   

end
