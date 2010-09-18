class RecentProductsPortlet < Portlet

  def render
    @products = Product.all(:order => "created_at desc", :limit => self.limit)
  end
    
end