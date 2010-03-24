Create Procedure getforumfromthreadid @threadid int
As
	SELECT ForumID FROM Threads WHERE ThreadID = @threadid

return (0)