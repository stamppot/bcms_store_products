class AddOrderLineItems < ActiveRecord::Migration
  def self.up
    change_table :line_items do |t|
      t.belongs_to :order
    end
  end

  def self.down
    change_table :line_items do |t|
    end
  end
end
