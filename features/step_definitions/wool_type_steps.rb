Given /^I have no wool types$/ do
  FoodType.delete_all
end

Given /^I have wool types named (.+)$/ do |names|
  names.split(' and ').each do |name|
    Factory(:food_type, :name => name)
  end
end

Then /^I should have ([0-9]+) wool types?$/ do |count|
  FoodType.count.should == count.to_i
end