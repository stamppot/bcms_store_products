class AddOrderConfirmation < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.boolean :confirmed
			t.datetime :confirmed_on
    end
  end

  def self.down
    change_table :orders do |t|
    end
  end
end
