module Cms::Routes
  def routes_for_bcms_store_products
    add_product_to_cart "/store/add_to_cart", :controller => '/store', :action => 'add_to_cart', :conditions => {:method => :put}
    add_product_to_cart "/store/remove_from_cart", :controller => '/store', :action => 'remove_from_cart', :conditions => {:method => :put}
    update_cart "/store/update_cart", :controller => '/store', :action => 'update_cart', :conditions => {:method => :post}
    checkout "/store/checkout", :controller => '/store', :action => 'checkout'
    shipping "/store/shipping", :controller => '/store', :action => 'shipping'
    payment "/store/payment", :controller => '/store', :action => 'payment'
    confirm_order "/store/confirm_order", :controller => '/store', :action => 'confirm_order', :conditions => {:method => :put}
		# finished_order "/store/finish", :controller => '/store', :action => 'finished_order'
		
    resources :orders, :new => { :paypal_express => :get, :create => :post, :ship => :post }

    resources :products
    
    namespace(:cms) do |cms|
      cms.content_blocks :product_photos
      cms.content_blocks :producers
      cms.content_blocks :products
      cms.content_blocks :product_types
      cms.content_blocks :food_types
    end
  end
end
