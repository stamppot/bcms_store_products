class PaymentPortlet < Portlet

  def render
    @cart = Cart.current_cart(session)
    @items = @cart.line_items
		@order = @cart.order || Order.new(flash[:record])
  end

  # def create # was: charge
    # Assume the current cart exists
    # cart = Cart.current_cart(session)
    # Google checkout creates an order using the polling api
    # @order = cart.order
    # if(!@order)
    #   @order = cart.build_order(params[:order])
    #   @order.payment_processor = 'paypal_express'
    #   @order.financial_state = 'CHARGEABLE'
    #   @order.fulfillment_state = 'NEW'
    # end

    # @order.ip_address = request.remote_ip
    # if @order.save
    #   @transaction = @order.purchase
    #   if @transaction.success
    #     render :action => "success"
    #   else
    #     render :action => "failure"
    #   end
    # else
    #   render :action => 'new'
    # end
  # end

end