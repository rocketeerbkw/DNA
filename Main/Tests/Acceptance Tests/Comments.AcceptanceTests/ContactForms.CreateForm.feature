Feature: Creating Contact Forms

Scenario: Creating a Contact Form with valid input data
	Given I am logged in as an editor
	When I call the Create Contact Form API with valid data
	Then I get a 201 Response code
	
Scenario: Creating a Contact Form with invalid site set
	Given I am logged in as an editor
	When I call the Create Contact Form API with an invalid site
	Then I get an Unknown Site Exception
	
Scenario: Creating a Contact Form with no form data
	Given I am logged in as an editor
	When I call the Create Contact Form API with no form data
	Then I get an Invalid Contact Email Exception
	
Scenario: Creating a Contact Form with no contact email
	Given I am logged in as an editor
	When I call the Create Contact Form API with no contact email
	Then I get an Invalid Contact Email Exception
	
Scenario: Creating a Contact Form with invalid contact email
	Given I am logged in as an editor
	When I call the Create Contact Form API with an invalid contact email
	Then I get an Invalid Contact Email Exception
	
Scenario: Creating a Contact Form as a normal user
	Given I am logged in as a normal user
	When I call the Create Contact Form API with valid data
	Then I get an Not Authorised Exception
	
Scenario: Creating a Contact Form with no forum UID
	Given I am logged in as an editor
	When I call the Create Contact Form API with no forum UID
	Then I get an Invalid Forum UID Exception
	
Scenario: Creating a Contact Form with no Parent Uri
	Given I am logged in as an editor
	When I call the Create Contact Form API with no parent uri
	Then I get an Invalid Forum Parent URI Exception
	
Scenario: Creating a Contact Form with invalid Parent Uri
	Given I am logged in as an editor
	When I call the Create Contact Form API with invalid parent uri
	Then I get an Invalid Forum Parent URI Exception
	
Scenario: Creating a Contact Form with not title
	Given I am logged in as an editor
	When I call the Create Contact Form API with no title
	Then I get an Invalid Forum Title Exception
	
@ignore	
Scenario: New Contact form entry first post
	Given a user goes to a page with a contact form on it
	When the first submission has been done on it
	Then the contact form is created without editor involvement

@ignore
Scenario: Contact Form Created with anonymous posting set as '<Anon_Post>'
	Given a user goes to a page with a contact form on it
	And the contact form has anonymous posting set to '<Anon_Post>'
	When anonymous user tries to post to it
	Then the posts is '<Post_Status>'

	|Anon_Post|Post_Status|
	|True|accepted|
	|False|rejected|
