Create Procedure getmostrecentforumthread @forumid int
As
SELECT TOP 1 ForumID, ThreadID FROM Threads 
	WHERE ForumID = @forumID
	ORDER BY LastPosted DESC
	return (0)