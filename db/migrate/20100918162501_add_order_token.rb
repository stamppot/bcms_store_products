class AddOrderToken < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :token, :limit => 8
    end
  end

  def self.down
    change_table :orders do |t|
    end
  end
end
