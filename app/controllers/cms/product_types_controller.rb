class Cms::ProductTypesController < Cms::ContentBlockController
  
  def create
    puts "CREATE ProductType params: #{params.inspect}"
    super
  end
  
end