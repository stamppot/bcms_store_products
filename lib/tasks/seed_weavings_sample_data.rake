namespace :db do
  namespace :seed do
    desc "Create pages and portlets required by the products module."
    task :products => :environment do
      class LoadProductsSeedData
        extend Cms::DataLoader

        # Set up the sections and pages
        create_section(:products, :name => "Products", :parent => Section.find_by_path("/"), :path => "/products")
        create_section(:administration, :name => "Administration", :parent => sections(:products), :path => "/products/administration", :hidden => true)
        Group.all.each{|g| g.sections = Section.all }
        # Remove the guest user from the products administration
        sections(:administration).groups.delete Group.find_by_code('guest')
        sections(:administration).save

        # Use the home page template if it exists otherwise use default
        template_file_name = File.exists?('app/views/layouts/templates/home_page.html.erb') ? 'home_page.html.erb' : 'default.html.erb'

        # Public section
        create_page(:overview, :name => "Overview", :path => "/products", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:product_process, :name => "Product Process", :path => "/products/product-process", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:producers, :name => "Producers", :path => "/products/producers", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:products, :name => "Products", :path => "/products/products", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:product, :name => "Product", :path => "/products/product", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => true, :cacheable => true)
        create_page(:items_for_sale, :name => "Items for Sale", :path => "/products/items-for-sale", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:donate, :name => "Donate", :path => "/products/donate", :section => sections(:products), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)

        # Administration section
        create_page(:orders, :name => "Orders", :path => "/products/administration/orders", :section => sections(:administration), :template_file_name => template_file_name, :publish_on_save => true, :hidden => true, :cacheable => true)

        # Set up some portlets
        set_up_portlet "recent_products_portlet", 'app/views/portlets/recent_products/render.html.erb',
          { "name" => "What's New?", "connect_to_page_id" => Page.find_by_path('/products/products').id, :limit => 10 }

        set_up_portlet "cart_portlet", 'app/views/portlets/cart/render.html.erb',
          { "name" => "Cart", "connect_to_page_id" => Page.find_by_path('/products/products').id }

        set_up_portlet "orders_portlet", 'app/views/portlets/orders/render.html.erb',
          { "name" => "Orders", "connect_to_page_id" => Page.find_by_path('/products/administration/orders').id, :results_per_page => 50 }

        set_up_portlet "browse_products_portlet", 'app/views/portlets/browse_products/render.html.erb',
          { "name" => "Browse Products", "connect_to_page_id" => Page.find_by_path('/products/items-for-sale').id, :results_per_page => 20 }

        set_up_portlet "product_details_portlet", 'app/views/portlets/product_details/render.html.erb',
          { "name" => "Product Details", "connect_to_page_id" => Page.find_by_path('/products/product').id }
      end
    end

    desc "Add some sample data to the database."
      task :sampledata => :environment do
        class LoadProductsSampleData
          # Make sure the relevant pages exist
          Rake::Task['db:seed:products'].invoke

          Producer.create(:name => 'Joe', :last_name => 'Bloggs', :description => 'An awesome producer.').publish!
          ProductType.create(:name => 'Rug', :danish_name => 'foo', :low_stock_level => 10, :user_id => 0, :description => 'You can stand on it').publish!
          FoodType.create(:name => 'Sheep', :description => 'Some pretty common wool').publish!
          counter = 1
          w = Product.create(:item_number => '001', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 231.21, :summary_description => 'Summary goes here.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          w = Product.create(:item_number => '002', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 40.12, :summary_description => 'Summary goes here.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          w = Product.create(:item_number => '003', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 432, :summary_description => 'Summary goes here.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          w = Product.create(:item_number => '004', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 3, :summary_description => 'Summary goes here.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          w = Product.create(:item_number => '005', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 95, :summary_description => 'Summary goes here.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          w = Product.create(:item_number => '006', :producer_id => Producer.find_by_name('Joe', :first).id, :product_type_id => ProductType.find_by_name('Rug', :first).id,
            :food_type_id => FoodType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 1, :summary_description => 'I should have an image.', :description => 'Description of product here.', :published => true)
          set_up_product_photos w, counter ; counter += 3
          end
      end
  end
  private
  def set_up_product_photos product, start_index
    count = start_index
    set_up_product_photo product, 'products_test_photos/' + count.to_s + '.jpg', 'product_photo_front_' + product.id.to_s + '.jpg', 'photo_for_product_' + product.id.to_s + '_front.jpg'
    count += 1
    set_up_product_photo product, 'products_test_photos/' + count.to_s + '.jpg', 'product_photo_back_' + product.id.to_s + '.jpg', 'photo_for_product_' + product.id.to_s + '_back.jpg'
    count += 1
    set_up_product_photo product, 'products_test_photos/' + count.to_s + '.jpg', 'product_photo_misc_' + product.id.to_s + '.jpg', 'photo_for_product_' + product.id.to_s + '_misc.jpg'
  end

  def set_up_product_photo product, file_path, original_name, product_photo_name
    require 'test_help'
    tempfile = ActionController::UploadedTempfile.new(original_name)
    realfile = File.open file_path
    open(tempfile.path, 'w') {|f| f << realfile.read}
    tempfile.original_path = original_name
    tempfile.content_type = 'image/jpeg'

    photo_front = ProductPhoto.new :name => product_photo_name, :attachment_file => tempfile, :published => true
    photo_front.product = product
    photo_front.save
    photo_front.publish!
  end

  def set_up_portlet portlet_name, template_path, portlet_arguments
    template_file = RAILS_ROOT + '/' + template_path
    template = ''
    # If the template file does not exist we are running out of the gem so grab the template file from there
    # TODO: Implement this in a more robust way
    template_file = '/usr/lib/ruby/gems/1.8/gems/bcms_store_products-1.0.0/' + template_path unless File.exists? template_file
    File.open(template_file, "r") { |f| template = f.read }

    portlet_arguments[:template] = template
    portlet_arguments[:handler] = "erb" unless portlet_arguments[:handler]
    portlet_arguments[:connect_to_container] = "main" unless portlet_arguments[:connect_to_container]
    portlet = portlet_name.classify.constantize.new(portlet_arguments)
    portlet.save
  end
end
