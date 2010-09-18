class CreateProductTypes < ActiveRecord::Migration
  def self.up
    create_versioned_table :product_types do |t|
      t.string :name 
      t.string :danish_name 
      t.integer :low_stock_level 
      t.text :description, :size => (64.kilobytes + 1)
      t.belongs_to :user
      t.belongs_to :attachment
      t.integer :attachment_version
    end

    ContentType.create!(:name => "ProductType", :group_name => "Products")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'ProductType'])
    CategoryType.all(:conditions => ['name = ?', 'Product Type']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :product_type_versions
    drop_table :product_types
  end
end
