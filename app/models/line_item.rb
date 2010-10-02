class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :order
  belongs_to :product
  validates_presence_of :product
  validates_presence_of :quantity
  validates_presence_of :unit_price
  
  def danish_unit_price
		LineItem.to_danish_price(unit_price)
  end

  def danish_total_price
		LineItem.to_danish_price(unit_price * quantity)
  end

  def self.for_product(product, quantity)
    item = self.new
    item.quantity = quantity
    item.product = product
    item.unit_price = product.offer_price > 0 && product.offer_price || product.selling_price
    item
  end

  def self.to_danish_price(price)
    pr = ("%05.2f" % ((price * 100).round / 100.0)).gsub(".", ",")
    pr << "0" if pr[-3,1] = ","
  end
end