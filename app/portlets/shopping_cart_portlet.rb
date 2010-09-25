class ShoppingCartPortlet < Portlet
  def render
    @cart = Cart.current_cart(session)
    @products_in_cart = []
    if @cart && @cart.line_items
      @products_in_cart = @cart.line_items.map {|item| item.product }.flatten
      @line_items = @cart.line_items
    end
  end
end
