class Customer < ActiveRecord::Base
  acts_as_content_block
  has_many :orders
end