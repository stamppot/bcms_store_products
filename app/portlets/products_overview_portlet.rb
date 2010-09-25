class ProductsOverviewPortlet < Portlet
  enable_template_editor true
  
  def render
    if params[:type]
      # We should search by product type
      @products_to_browse = Product.published.of_product_type(params[:type]).all.compact 
      @search_results_summary = 'Fandt ' + @products_to_browse.size.to_s + ' products of type ' + ProductType.find(params[:type]).name
    else
      @products_to_browse = Product.published.all
    end
    
  end
end