require "spec_helper"

describe "Product" do

  it "should have an item number which is unique" do
    # Should not be valid without an item number
    product = Factory.build(:product, :item_number => nil)
    product.should_not be_valid

    # Should be valid once an item number is assigned
    product.item_number = '100'
    product.should be_valid
    product.save

    # Should not allow another product with the same item number
    product = Factory.build(:product, :item_number => '100')
    product.should_not be_valid

    # A different item number should make the product valid
    product.item_number = '200'
    product.should be_valid
  end

  it "should have a description" do
    # Should not be valid without a description
    product = Factory.build(:product, :description => nil)
    product.should_not be_valid

    # Should be valid once a description is assigned
    product.description = 'A really cool product.'
    product.should be_valid
  end

  it "should have a summary description" do
    # Should not be valid without a summary description
    product = Factory.build(:product, :summary_description => nil)
    product.should_not be_valid

    # Should be valid once a summary description is assigned
    product.summary_description = 'Something catchy.'
    product.should be_valid
  end

  it "should have a published product type" do
    # Should not be valid without product type
    product = Factory.build(:product, :product_type => nil)
    product.should_not be_valid

    # Should not be valid with an unpublished product type
    product_type = Factory.build(:product_type, :published => false)
    product.product_type = product_type
    product.should_not be_valid

    # Should be valid once the product type is published
    product_type.publish!
    product.should be_valid
  end

  it "should have a published producer" do
    # Should not be valid without producer
    product = Factory.build(:product, :producer => nil)
    product.should_not be_valid

    # Should not be valid with an unpublished producer
    producer = Factory.build(:producer, :published => false)
    product.producer = producer
    product.should_not be_valid

    # Should be valid once the producer is published
    producer.publish!
    product.should be_valid
  end

  it "should have a published wool type" do
    # Should not be valid without wool type
    product = Factory.build(:product, :food_type => nil)
    product.should_not be_valid

    # Should not be valid with an unpublished wool type
    food_type = Factory.build(:food_type, :published => false)
    product.food_type = food_type
    product.should_not be_valid

    # Should be valid once the wool type is published
    food_type.publish!
    product.should be_valid
  end

  it "should search by item number (not name) in content library" do
    # The item_number and name are normally the same as the module only sets item_number
    # (check product model for explanation)
    product = Factory.build(:product)
    product.name = 'bar'
    product.item_number = 'foo'
    product.save

    # When I search for the item_number the product should be in the result set
    Product.search(:term => 'foo').find_all{|w| w == product }.size.should be(1)

    # When I search for the name the product should not be in the result set
    Product.search(:term => 'bar').find_all{|w| w == product }.size.should be(0)
  end
end
