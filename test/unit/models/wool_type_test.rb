require File.join(File.dirname(__FILE__), '/../../test_helper')

class FoodTypeTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert FoodType.create!
  end
  
end