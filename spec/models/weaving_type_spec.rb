require "spec_helper"

describe "Product Type" do

  it "should have a unique name" do
    # Product Type should not be valid without a name
    product_type = ProductType.new
    product_type.should_not be_valid

    # Product Type should be valid once named
    product_type.name = 'Shawl'
    product_type.should be_valid
    product_type.save

    # A Product Type with the same name should not be valid
    product_type = ProductType.new :name => 'Shawl'
    product_type.should_not be_valid

    # When the name is changed it should be valid
    product_type.name = 'Rug'
    product_type.should be_valid
  end
end
