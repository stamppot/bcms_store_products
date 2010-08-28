Factory.define :product_type do |f|
  f.sequence(:name) { |n| "Shawl#{n}" }
  f.published true
end

Factory.define :food_type do |f|
  f.sequence(:name) { |n| "Sheep#{n}" }
  f.published true
end

Factory.define :producer do |f|
  f.sequence(:name) { |n| "Bob#{n}" }
  f.published true
end

Factory.define :product do |f|
  f.sequence(:item_number) { |n| "W00#{n}" }
  f.product_type { |product_type| product_type.association(:product_type) }
  f.food_type { |food_type| food_type.association(:food_type) }
  f.producer { |producer| producer.association(:producer) }
  f.summary_description 'Summary description goes here.'
  f.description 'Product description goes here.'
end
