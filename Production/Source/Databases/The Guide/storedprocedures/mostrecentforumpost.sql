CREATE  PROCEDURE mostrecentforumpost @forumid int 
AS
SELECT 'MostRecent' = MAX(t.DatePosted) 
FROM Forums f, ThreadEntries t
WHERE t.ForumID = f.ForumID
AND f.ForumID = @forumid
