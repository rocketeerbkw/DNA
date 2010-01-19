CREATE  PROCEDURE forumthreadcount @forumid int
AS
SELECT 'ThreadCount' = COUNT(*) From Threads WHERE ForumID = @forumid AND VisibleTo IS NULL
