CREATE PROCEDURE getnumberofusersubmittedevents @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of user submitted events that were submitted within a date range. */
	SELECT COUNT (DISTINCT t.ThreadID)
	  FROM dbo.Threads t WITH (NOLOCK)
			INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = t.ForumID
			INNER JOIN dbo.ThreadEntries te WITH (NOLOCK) ON te.ThreadID = t.ThreadID and te.ForumID = t.ForumID
			INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = te.UserID AND u.Status = 1
			LEFT JOIN dbo.GroupMembers gm WITH (NOLOCK) ON gm.UserID = u.UserID AND gm.SiteID = @siteid AND gm.GroupID NOT IN (8, 198, 205, 207, 214)
	 WHERE t.Type = 'Event'
	   AND f.SiteID = @siteid
	   AND te.DatePosted BETWEEN @startdate AND @enddate

RETURN @@ERROR 