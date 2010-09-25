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
 
		redirect_to '/shop/shopping_cart'
	rescue
		flash[:notice] = "Produktet findes ikke."
		redirect_to '/shop' and return
	end
	
	def update_cart										 
		puts "PARAMS: #{params.inspect}"
		@cart = Cart.current_cart(session)	
		puts "CART: #{@cart.inspect} " + @cart.line_items.map {|i| i.inspect}.join(", ")
		params[:cart_quantity].each do |product_id, quantity|
			item = @cart.line_items.select { |item| item.product_id == product_id.to_i }.first
			item.quantity = quantity
			item.save
			puts "UPDATED item #{item.inspect} to quantity #{quantity}"
		end
		if params[:cart_delete]
			@cart.line_items.each { |item| item.destroy if params[:cart_delete].include? item.product_id.to_s }
		end
	
		flash[:notice] = "Indkøbskurven er opdateret"
		redirect_to '/shop/shopping_cart'
	end
	
	def empty_cart
		@cart = Cart.current_cart(session)
		@cart.empty!
		flash[:notice] = 'Din indkøbskurv er tømt'
		redirect_to '/shop'
	end

	def remove_from_cart
		cart = Cart.current_cart(session)
		remove_item = cart.line_items.detect { |item| item.product_id.to_s == params["product"]["id"] }
		if remove_item.quantity == 1
			remove_item.destroy
		else
			remove_item.quantity -= 1
			remove_item.save
		end

		# FIXME: Use the real return path
		redirect_to '/shop'
	end			
							
	def shipping					
		@cart = Cart.current_cart(session)
		@order = @cart.order || Order.new(params["order"])
		@order.update_attributes params["order"] unless @order.new_record?
		return unless @cart || @cart.line_items.empty?
		@order.cart = @cart	
		@order.ip_address = request.remote_ip
		@order.token = rand(36**8).to_s(36)
		@cart.line_items.each {|item| @order.line_items << item; item.save }
		@items = @cart.line_items
		if @order.save
			puts "SHIPPING: #{@order.id}"
			@cart.order = @order
			redirect_to '/shop/payment'
		else
			flash[:error] = "error"
			flash[:record] = params["order"]
			redirect_to '/shop/shipping'
		end
	end
	
	def payment # capture payment information
		# check if order_id of cart has been set
		@cart = Cart.current_cart(session)
		@order = @cart.order
		puts "PAYMENT: #{@order.id}"
		@order.update_attributes params["order"]
		if @order.save
			@cart.order = @order
			redirect_to '/shop/order_confirmation'
		else
			flash[:error] = "error"
			flash[:record] = params["order"]
			redirect_to '/shop/payment'
		end
	end
	
	def confirm_order
		@cart = Cart.current_cart(session)
		@order = @cart.order
		if @cart.id.to_s == params["order"]["id"].to_s
			@order.confirm = true
			@order.confirmed_on = DateTime.now
		else
			flash[:error] = "Wrong cart!"
		end
		puts "CONFIRM_ORDER: #{@order.id}"
		# @cart.line_items.each {|item| @order.line_items << item; item.save }
		if @order.save
			@cart.order = @order
			# @cart.empty!
			redirect_to '/shop/'
		else
			flash[:error] = "error"
			flash[:record] = params["order"]
			redirect_to '/shop/order_confirmation'
		end
		# redirect_to '/shop/order_confirmation'
	end
	
	# def finished_order
	#		flash["Du har købt noget i butikken!"]
	#		redirect_to '/shop'
	# end	 

end
