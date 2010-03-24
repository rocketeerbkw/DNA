CREATE PROCEDURE getprevandnextposts @forumid int, @threadid int
As
declare @nextthread int, @prevthread int
SELECT TOP 1 @nextthread = ThreadID FROM Threads
WHERE LastPosted > (SELECT LastPosted FROM Threads WHERE ForumID = @forumid AND ThreadID = @threadid)
AND VisibleTo IS NULL
AND ForumID = @forumid
ORDER BY LastPosted ASC

SELECT TOP 1 @prevthread = ThreadID FROM Threads
WHERE LastPosted < (SELECT LastPosted FROM Threads WHERE ForumID = @forumid AND ThreadID = @threadid)
AND VisibleTo IS NULL
AND ForumID = @forumid
ORDER BY LastPosted DESC

SELECT 'ForumID' = @forumid, 'PrevThread' = @prevthread, 'NextThread' = @nextthread