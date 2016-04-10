Feature: Users can add tags to transactions

	Scenario: User creates tag
		Given I am on the home page
		When I create a tag "amazon"
		Then I am taken to the "amazon" tag page
