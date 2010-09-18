class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.belongs_to :product
      t.integer :quantity
      t.decimal :unit_price, :default => 0, :precision => 8, :scale => 2
    end

  end

  def self.down
    drop_table :line_items
  end
end
