class OrderDetailsPortlet < Portlet
  
  def render
    @order = Order.find_by_token(params[:id])
    redirect_to '/shop' unless @order
  end
  
end 