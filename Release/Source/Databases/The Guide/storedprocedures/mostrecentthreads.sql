CREATE  PROCEDURE mostrecentthreads @forumid int
AS
SELECT TOP 5 * From Threads WHERE ForumID = @forumid
ORDER BY LastPosted DESC
