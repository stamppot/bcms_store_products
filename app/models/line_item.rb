class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :order
  belongs_to :product
  validates_presence_of :product
  validates_presence_of :quantity
  validates_presence_of :unit_price
  
  def self.for_product(product, quantity)
    item = self.new
    item.quantity = quantity
    item.product = product
    item.unit_price = product.offer_price > 0 && product.offer_price || product.selling_price
    item
  end
end