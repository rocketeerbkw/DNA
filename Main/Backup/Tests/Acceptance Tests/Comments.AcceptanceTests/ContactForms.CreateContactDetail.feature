Feature: Creating Contact Details

Scenario: Create Contact Detail with invalid site name
	Given I am logged in as a normal user
	When I post a Contact Detail with invalid site name
	Then I get an Unknown Site Exception
	
Scenario: Create Contact Detail with no Form ID
	Given I am logged in as a normal user
	When I post a Contact Detail with no Form ID
	Then I get a Forum Unknown Exception
	
Scenario: Create Contact Detail with non logged in user
	Given I am not logged in
	When I post a Contact Detail with valid data
	Then I should get a Missing User Credentials Exception
	
Scenario: Create Contact Detail with no text
	Given I am logged in as a normal user
	When I post a Contact Detail with no text
	Then I should get an Empty Text Exception
	
Scenario: Create Contact Detail with valid data
	Given I am logged in as a normal user
	When I post a Contact Detail with valid data
	Then I get a 201 Response code