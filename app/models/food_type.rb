class FoodType < ActiveRecord::Base
  acts_as_content_block :belongs_to_attachment => true
  has_many :products

  named_scope :published, :conditions => {:published => true}

end
