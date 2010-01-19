CREATE PROCEDURE updatereviewforum	@reviewforumid int, 
										@name varchar(50),
										@url varchar(50),
										@recommend tinyint,
										@incubate int

As

Update reviewforums
Set Forumname = @name, URLFriendlyName = @url,Recommend = @recommend, IncubateTime = @incubate where reviewforumid = @reviewforumid

declare @success int
Set @success = 0
Select @success = reviewforumid from reviewforums where reviewforumid = @reviewforumid

select 'ID' = @success

return(0)