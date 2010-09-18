class OrderDetails < Portlet
  
  def render
    @order = Order.get_by_token(params[:id])
    redirect_to '/shop' unless @order
  end
  
end 