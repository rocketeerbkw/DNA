Feature: Admin Console Authorization

Scenario: Users with editor rights
	Given I am logged in as an editor
	When I visit the admin console as an editor
	Then I can see the Buzz Profile list page
	
Scenario: Users without editor rights
	Given I am logged in as a normal user
	When I visit the admin console as a normal user
	Then I should see an appropriate error message