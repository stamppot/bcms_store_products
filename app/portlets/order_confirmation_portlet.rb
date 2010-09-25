class OrderConfirmationPortlet < Portlet
  def render
    @cart = Cart.current_cart(session)
		@order = @cart.order || Order.new(flash[:record])
    @order.line_items = @cart.line_items
  end
end
