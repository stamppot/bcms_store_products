Feature: Manage Food Types
	In order to record information about products
	As a products administrator
	I Want to manage wool types

	Background:
		Given I am logged in as "cmsadmin" with password "cmsadmin"

	Scenario: Create Product Type
	    Given I have no wool types
	    And I am on the list of wool types
	    When I follow "ADD NEW CONTENT"
	    And I fill in "Name" with "Sheep"
	    And I fill in "Description" with "Food from the creatures you count when you can't sleep."
	    And I press "food_type_submit"
	    Then I should see "Food Type 'Sheep' was created"
	    And I should see "Sheep"
	    And I should see "Food from the creatures you count when you can't sleep."
	    And I should have 1 wool type