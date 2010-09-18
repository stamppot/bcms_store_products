class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :payer_status
      t.string :street_line_1
      t.string :street_line_2
      t.string :city
      t.string :country_code
      t.string :country_name
      t.string :zip
    end
    
    change_table :orders do |t|
      t.belongs_to :customer
    end
  end

  def self.down
    change_table :orders do |t|
    end
    drop_table :customers
  end
end
