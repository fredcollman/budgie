Feature: Users can import transactions from a file

	Scenario: User imports from Santander
		When I upload santander.txt
		Then the most recent transactions should be displayed

	Scenario: User imports duplicate transactions
		Given I have previously uploaded santander.txt
		When I upload santander.txt
		Then 0 transactions should be uploaded
