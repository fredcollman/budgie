Feature: Users can add tags to transactions

	Scenario: User creates tag
		Given I am on the home page
		When I create a tag "amazon"
		Then I am taken to the "amazon" tag page

	Scenario: User deletes tag
		Given I am on the page for the "rent" tag
		When I click the delete button
		Then the "rent" tag is no longer displayed

	Scenario: User edits tag
		Given I am on the page for the "hello" tag
		When I rename the tag to "goodbye"
		Then I am taken to the "goodbye" tag page

	Scenario: User tags a transaction
		Given the "fruit" tag exists
		And the transaction "bought some bananas" exists
		And I am on the home page
		When I tag the transaction "bought some bananas" with the tag "fruit"
		And I go to the "fruit" tag page
		Then I see the transaction "bought some bananas"
