class CreateFoodTypes < ActiveRecord::Migration
  def self.up
    create_versioned_table :food_types do |t|
      t.string :name 
      t.text :description, :size => (64.kilobytes + 1)
      t.belongs_to :attachment
      t.integer :attachment_version
    end

    ContentType.create!(:name => "FoodType", :group_name => "Products")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'FoodType'])
    CategoryType.all(:conditions => ['name = ?', 'Food Type']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :food_type_versions
    drop_table :food_types
  end
end
