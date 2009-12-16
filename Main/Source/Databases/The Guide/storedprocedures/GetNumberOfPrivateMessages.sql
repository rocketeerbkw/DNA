CREATE PROCEDURE getnumberofprivatemessages @startdate datetime, @enddate datetime
AS
	/* Returns the number of private message that have been sent in a date range. */
	SELECT COUNT(te.EntryID)
	  FROM Users u WITH (NOLOCK)
			INNER JOIN UserTeams ut ON ut.UserID = u.UserID -- AND ut.Siteid = @siteid?
			INNER JOIN Teams tm WITH (NOLOCK) ON tm.TeamID = ut.TeamID
			INNER JOIN Forums f WITH (NOLOCK) ON f.ForumID  = tm.ForumID
			INNER JOIN Threads t WITH (NOLOCK) ON t.ForumID = f.ForumID
			INNER JOIN ThreadEntries te WITH (NOLOCK) ON te.ThreadID = t.ThreadID and te.ForumID = t.ForumID
	 WHERE EXISTS (SELECT 1
					 FROM ThreadPostings tp WITH (NOLOCK)
					WHERE tp.ForumID = t.ForumID 
					  AND tp.Private = 1) -- i.e. Forum for private messages
	   AND te.DatePosted BETWEEN @startdate AND @enddate
					  
RETURN @@ERROR
