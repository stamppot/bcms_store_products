class CreateProductPhotos < ActiveRecord::Migration
  def self.up
    create_versioned_table :product_photos do |t|
      t.belongs_to :attachment
      t.integer :attachment_version
      t.belongs_to :product
    end

    # Do not create the menu because Product Photos are handeled by the product form
    #ContentType.create!(:name => "ProductPhoto", :group_name => "ProductPhoto")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'ProductPhoto'])
    CategoryType.all(:conditions => ['name = ?', 'Product Photo']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :product_photo_versions
    drop_table :product_photos
  end
end
