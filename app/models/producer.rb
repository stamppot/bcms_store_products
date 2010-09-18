class Producer < ActiveRecord::Base
  acts_as_content_block :belongs_to_attachment => true
  has_many :products
end
