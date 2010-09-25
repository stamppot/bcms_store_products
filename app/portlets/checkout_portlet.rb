class CheckoutPortlet < Portlet

  def render
    @cart = Cart.current_cart(session)
    @items = @cart.line_items
    if @items.empty?
      flash[:notice] = "Din indkøbskurv er tom"
      redirect_to '/shop'
    end
		@order = @cart.order || Order.new(flash[:record])
			# @order = Order.new flash[:record]  # is flash[:record]; ... else Order.new
    @order.line_items = @cart.line_items
  end

  def create # was: charge
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    # Google checkout creates an order using the polling api
    @order = cart.order
    # if(!@order)
    #   @order = cart.build_order(params[:order])
    #   @order.payment_processor = 'paypal_express'
    #   @order.financial_state = 'CHARGEABLE'
    #   @order.fulfillment_state = 'NEW'
    # end

    @order.ip_address = request.remote_ip
    if @order.save
      @transaction = @order.purchase
      if @transaction.success
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end

end