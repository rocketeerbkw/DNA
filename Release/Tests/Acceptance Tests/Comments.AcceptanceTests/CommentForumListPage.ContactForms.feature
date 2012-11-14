Feature: Ability to change the email address for a given contact forms
In order to be able to have different email address receipients for each contact form
As an editor
I need to have the ability to specify an email address per form

@ignore
Scenario: Existing comment forum amend contact email address
Given an exisiting comment forum
And a contact email address has already been associated to it
And I am logged in as an editor
When I go to the CommentForumList page
And amend the email address to '<email_address>'
And submit my changes
Then the chosen Forum is updated with the new '<email_address>'
|email_address|
|test@bbc.co.uk|

@ignore
Scenario: A non '@BBC.co.uk' contact email address is not allowed
Given an exisiting comment forum
And I am logged in as an editor
When I go to the CommentForumList page
And a non @BBC.co.uk address is entered
And submit my changes
Then an invalid contact email exception is thrown

@ignore
Scenario: Existing comment forum amend contact email address to blank
Given an exisiting comment forum
And a contact email address has already been associated to it
And I am logged in as an editor
When I go to the CommentForumList page
And amend the email address to blank
And there is a valid site default email address
And submit my changes
Then the returned contact form object contains the default site email address