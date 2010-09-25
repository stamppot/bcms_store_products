class RemoveOrderAttributes < ActiveRecord::Migration
  def self.up
		remove_column :orders, :payer_status
		remove_column :orders, :payment_processor
		remove_column :orders, :google_order_number
		remove_column :orders, :ship_to_country_code
		remove_column :orders, :first_name
		remove_column :orders, :last_name
		remove_column :orders, :paypal_express_token
		remove_column :orders, :financial_state
		remove_column :orders, :google_order_number
		remove_column :orders, :paypal_express_payer_id
		rename_column :orders, :ship_to_name, :name
		rename_column :orders, :ship_to_zip, :zip
		rename_column :orders, :ship_to_street_line_1, :street
		rename_column :orders, :ship_to_country_name, :country
		rename_column :orders, :ship_to_street_line_2, :street_2
		rename_column :orders, :carrier_tracking_number, :tracking_number
		add_column :orders, :card_holder, :string
		add_column :orders, :card_number, :string
		add_column :orders, :card_security, :string
  end

  def self.down
    add_column :orders, :payment_processor, :string
		remove_column :orders, :card_security
		remove_column :orders, :card_number
		remove_column :orders, :card_holder
    add_column :orders, :paypal_express_payer_id, :string
    add_column :orders, :google_order_number, :string
    add_column :orders, :financial_state, :string
    add_column :orders, :paypal_express_token, :string
    add_column :orders, :last_name, :string
    add_column :orders, :first_name, :string
		rename_column :table_name, :new_column_name, :column_name
		rename_column :orders, :tracking_number, :carrier_tracking_number
		rename_column :orders, :street_2, :ship_to_street_line_2
		rename_column :orders, :country, :ship_to_country_name
		rename_column :orders, :street, :ship_to_street_line_1
		rename_column :orders, :zip, :ship_to_zip
		rename_column :orders, :name, :ship_to_name

    add_column :orders, :ship_to_country_code, :string
    add_column :orders, :carrier_tracking_number, :string
    add_column :orders, :google_order_number, :string
    add_column :orders, :payer_status, :string
  end
end
