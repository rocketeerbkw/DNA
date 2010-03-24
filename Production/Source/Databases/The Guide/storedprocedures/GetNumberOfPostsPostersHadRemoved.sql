CREATE PROCEDURE getnumberofpostspostershadremoved @siteid INT, @startdate datetime, @enddate datetime 
AS
	/*
		Function: Returns the number of posts that posters had removed.

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS FailureCount, INT AS UserCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH UsersFailedPosts AS
	(
		SELECT UserID, count(PostID) AS 'FailureCount'
		  FROM dbo.ThreadMod tm
				INNER JOIN dbo.ThreadEntries te ON tm.PostID = te.EntryID
		 WHERE tm.SiteID = @siteid
		   AND tm.DateCompleted >= @startdate 
		   AND tm.DateCompleted < @enddate
		   AND (tm.Status = 4 OR tm.Status = 6) -- Failed
		 GROUP BY UserID
	)
	SELECT FailureCount, count(UserID) AS 'UserCount'
	  FROM UsersFailedPosts
	 GROUP BY FailureCount
	 ORDER BY FailureCount ASC

RETURN @@ERROR 