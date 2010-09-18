class Cms::ProductsController < Cms::ContentBlockController
  def create
    fix_price_params
    files = fix_params params
    super
    rename_attachments files, @block
  end

  def update
    fix_price_params
    files = fix_params params
    super
    rename_attachments files, @block
  end

  private
  
  def fix_price_params
    params[:product][:selling_price].gsub!(",", ".")
    params[:product][:purchase_price].gsub!(",", ".")
    params[:product][:offer_price].gsub!(",", ".")
  end
  
  def fix_params params
    # Remember the temp files
    result = { :photo_front_attachment_file => params[:product][:product_photo_front],
      :photo_back_attachment_file => params[:product][:product_photo_back],
      :photo_misc_attachment_file => params[:product][:product_photo_misc] }

    # Delete the things that confuse the normal product creation (since BrowserCMS does not handle multiple attachments properly)
    params[:product].delete :product_photo_front
    params[:product].delete :product_photo_back
    params[:product].delete :product_photo_misc
    params.delete :temp

    result
  end

  def rename_attachments files, block
    # Forcilby specify what to save the filename as (since passing :attachment_file_path => '/attachments/another_filename' to ProductPhoto.new seems to be ignored)
    files[:photo_front_attachment_file].instance_variable_set :@original_filename, 'product_photo_front_' + block.id.to_s + rand(10000).to_s + '.jpg'
    files[:photo_back_attachment_file].instance_variable_set :@original_filename, 'product_photo_back_' + block.id.to_s + rand(10000).to_s + '.jpg'
    files[:photo_misc_attachment_file].instance_variable_set :@original_filename, 'product_photo_misc_' + block.id.to_s + rand(10000).to_s + '.jpg'

    # FIXME: Currently just destroying the old photos and adding new ones
    # This breaks the versioning but allows updating but not reverting
    # I couldn't get update_attributes to work
    # It means that if you only change two of the photos it will delete the other
    # Will just make all photos manditory to fix this for now
    block.product_photos[0].destroy if block.product_photos[0]
    block.product_photos[1].destroy if block.product_photos[1]
    block.product_photos[2].destroy if block.product_photos[2]

    # Discarding original names because we can only get the last attachment
    # TODO: see if we can set the name from the attached file so the system can fix any naming conflicts automatically
    photo_front = ProductPhoto.new :name => 'photo_for_product_' + block.id.to_s + '_front.jpg', :attachment_file => files[:photo_front_attachment_file], :published => true
    photo_back = ProductPhoto.new :name => 'photo_for_product_' + block.id.to_s + '_back.jpg', :attachment_file => files[:photo_back_attachment_file], :published => true
    photo_misc = ProductPhoto.new :name => 'photo_for_product_' + block.id.to_s + '_misc.jpg', :attachment_file => files[:photo_misc_attachment_file], :published => true

    photo_front.product = block
    photo_front.save
    photo_front.publish!
    photo_back.product = block
    photo_back.save
    photo_back.publish!
    photo_misc.product = block
    photo_misc.save
    photo_misc.publish!
  end
end