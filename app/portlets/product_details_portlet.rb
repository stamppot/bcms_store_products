class ProductDetailsPortlet < Portlet

  def render
    @product = Product.find(params[:id])
  end

end