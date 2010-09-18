class Product < ActiveRecord::Base
  acts_as_content_block
  # validates_presence_of :item_number
  attr_accessor :quantity
  
  validates_presence_of :name
  validates_presence_of :selling_price
  validates_uniqueness_of :item_number
  validates_presence_of :summary_description
  validates_presence_of :description
  validates_each :product_type do |record, attr, value|
    if record.product_type
      record.errors.add attr, 'must be published' unless record.product_type.published?
    else
      record.errors.add attr, 'must be specified'
    end
  end
  validates_each :producer do |record, attr, value|
    if record.producer
      record.errors.add attr, 'must be published' unless record.producer.published?
    else
      record.errors.add attr, 'must be specified'
    end
  end
  validates_each :food_type do |record, attr, value|
    if record.food_type
      record.errors.add attr, 'must be published' unless record.food_type.published?
    # else
    #   record.errors.add attr, 'must be specified'
    end
  end
  belongs_to :producer
  belongs_to :product_type
  belongs_to :food_type
  belongs_to :cart
  has_many :product_photos

  named_scope :published, :conditions => {:published => true}
  named_scope :of_product_type, lambda { |id| { :conditions => ['product_type_id = ?', id] } }
  
  # Products should be identified by their item number but BrowserCMS is hell bent on using :name
  # Created this so this module can refer to item_number and name will just contain a copy of item_number
  # so things like searching in the content library work as expected.
  # This module should not use the field product.name (use Product.item_number instead)
  def item_number=(new_item_number)
    # write_attribute(:name, new_item_number)
    write_attribute(:item_number, new_item_number)
  end
  
  def product_type_name
    self.product_type.name
  end

  def self.columns_for_index
    [ {:label => "Navn", :method => :name, :order => "item_number" },
      {:label => "Produktnr", :method => :item_number, :order => "item_number" },
      {:label => "Produkttype", :method => :product_type_name }
     ]
  end

  def self.default_order
    "item_number asc"
  end
end
