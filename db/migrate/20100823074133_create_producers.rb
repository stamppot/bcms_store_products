class CreateProducers < ActiveRecord::Migration
  def self.up
    create_versioned_table :producers do |t|
      t.string :name
      t.string :last_name
      t.text :description, :size => (64.kilobytes + 1) 
      t.belongs_to :attachment
      t.integer :attachment_version
    end
    
    ContentType.create!(:name => "Producer", :group_name => "Products")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Producer'])
    CategoryType.all(:conditions => ['name = ?', 'Producer']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :producer_versions
    drop_table :producers
  end
end
