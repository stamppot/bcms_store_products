class ListProductTypesPortlet < Portlet
  def render
    @product_types = ProductType.find(:all)

    if params[:type]
      # We should search by product type
      @products_to_browse = Product.find(:all, :conditions => ["published = ? AND product_type_id = ?", true, params[:type]]).compact
      @search_results_summary = 'Fandt ' + @products_to_browse.size.to_s + ' products of type ' + ProductType.find(params[:type]).name
    end
  end
end