Feature: Display distress messages with original post
In order to display distress messages
As a referee
I want to be able to post a message and it be shown on the page with the message it relates to

@ignore
Scenario Outline: Create Distress Message against a post
Given I have an comment in the referal queue
When I want to place a distress message against a comment
And the forum is sorted by '<SortBy>' '<SortDirection>'
Then the distress message will appear in the comments module as a reply to the referred message

@ignore
Scenario: Editors Pick Message still shows associated Distress Message
Given a comment has a distress message against it
When that comment is made an Editors' Pick
And the page filter has been set to show Editors Picks
And the forum is sorted by '<SortBy>' '<SortDirection>'
Then the distress message will appear in the comments module as a reply to the referred message 

Examples: 
| SortBy		| SortDirection |
| Created		| Ascending     | 
| Created		| Descending    |
| RatingValue   | Ascending     |
| RatingValue   | Descending    |

