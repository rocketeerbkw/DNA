Feature: Anonymous users can post onto forums even if first post has been done by a user who is signed in
In order to allow anonymous user posting to a forum even if the first post has been posted as signed in user
as an anonymous user on a forum
I want to be able to add to the forum even if the first post in that forum was completed by someone signed in

Scenario: Forum set up to accept anonymous posting
Given a forum has been setup to allow anonymous posting
When a user who is not signed in goes to the forum
And posts to it
Then the post is successfully placed
And adds correctly to the forum

Scenario: Forum set up to accept anonymous posting and first post against it has been done by a signed in user
Given a forum has been setup to allow anonymous posting
And has had an post already against it by a user who is signed in
When an anonymous user goes to the same forum
And posts to it
Then the post is successfully placed
And adds correctly to the forum

Scenario: Forum has been setup to only allow signed in users to post to it
Given a forum allows only signed in users to add to it
When anonymous user tries to post to it
Then they are given a message saying they need to be signed in or regsistered to post
And the post is not added