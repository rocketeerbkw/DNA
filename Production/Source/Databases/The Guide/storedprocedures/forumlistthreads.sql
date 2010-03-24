CREATE   PROCEDURE forumlistthreads @forumid int
AS
SELECT ThreadID, FirstSubject FROM Threads WHERE ForumID = @forumid

