Feature: Users can define rules for custom import behaviour

	Scenario: User import with tag rule
		Given there is an active rule which tags all new entries with "banana"
		When I upload santander.txt
		Then the most recent entry should be tagged with "banana"
