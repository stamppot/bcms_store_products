class CreateProducts < ActiveRecord::Migration
  def self.up
    create_versioned_table :products do |t|
      t.belongs_to :producer
      t.belongs_to :product_type
      t.belongs_to :food_type
      t.belongs_to :cart
      t.string :item_number
      t.string :name
      t.decimal :purchase_price, :default => 0, :precision => 8, :scale => 2 
      t.decimal :purchase_price_euro, :default => 0, :precision => 8, :scale => 2
      t.decimal :selling_price, :default => 0, :precision => 8, :scale => 2
      t.decimal :offer_price, :decimal, :default => 0, :precision => 8, :scale => 2
      t.string :summary_description
      t.text :description, :size => (64.kilobytes + 1)
    end

    # ContentType.create!(:name => "Product", :group_name => "Products")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Product'])
    CategoryType.all(:conditions => ['name = ?', 'Product']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :product_versions
    drop_table :products
  end
end
