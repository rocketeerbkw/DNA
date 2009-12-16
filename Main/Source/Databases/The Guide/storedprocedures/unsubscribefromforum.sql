create procedure unsubscribefromforum @userid int, @forumid int
as
DELETE FROM FaveForums WHERE UserID = @userid AND ForumID = @forumid