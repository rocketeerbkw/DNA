CREATE PROCEDURE subscribedthreads @userid int
AS
/*
SELECT * FROM Threads t 
	INNER JOIN FaveForums f 
		ON f.UserID = @userid
			AND f.ForumID = t.ForumID 
			AND (f.ThreadID = t.ThreadID 
				OR f.ThreadID IS NULL)
WHERE f.LastRead < t.LastPosted OR f.LastRead IS NULL
ORDER BY t.LastPosted DESC

*/