Feature: Users can import transactions from a file

	Scenario: User imports from Santander
		When I upload santander.txt
		Then the most recent transaction should be displayed first

	Scenario: User imports duplicate transactions
		Given I have previously uploaded santander.txt
		When I upload santander.txt
		Then 0 transactions should be uploaded
