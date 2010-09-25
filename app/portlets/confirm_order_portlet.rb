class ConfirmOrderPortlet < Portlet

  def render
    @cart = Cart.current_cart(session)
    @items = @cart.line_items
		@order = @cart.order || Order.new(flash[:record])
    @order.line_items = @cart.line_items
  end

end