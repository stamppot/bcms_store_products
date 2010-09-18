class ProductType < ActiveRecord::Base
  acts_as_content_block :belongs_to_attachment => true
  has_many :products
  belongs_to :user
  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :published, :conditions => {:published => true}

end
