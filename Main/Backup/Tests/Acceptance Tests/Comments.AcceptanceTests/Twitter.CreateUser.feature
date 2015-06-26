Feature: Create Twitter Users
	In order to ensure stats for new users are correct
	As an editor for a given site
	I want new twitter users to be added to the correct site

@ignore
Scenario: User associated to the same site as a new profile
	Given I am logged in as an editor
	When I create a profile with a valid twitter user that does not already exist in DNA
	Then the user is created in the same site as the profile

@ignore
Scenario: User associated to the same site as the existing profile
	Given I am logged in as an editor
	When I update a profile with a valid twitter user that does not already exist in DNA
	Then the user is created in the same site as the profile
	