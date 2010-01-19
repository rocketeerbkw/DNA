Create Procedure unsubscribefromthread @userid int, @threadid int, @forumid int
as
IF EXISTS (SELECT * FROM Users WHERE UserID = @userid AND Journal = @forumid)
BEGIN
-- don't let them unsubscribe from journal threads
SELECT 'Result' = 4, 'Reason' = 'You can''t unsubscribe from your own Journal'
END
ELSE
BEGIN
DELETE FROM ThreadPostings
	WHERE UserID = @userid AND ThreadID = @threadid AND ForumID = @forumid
SELECT 'Result' = 0
END