CREATE PROCEDURE getnumberofusercommentsonnotices @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of user comments on notices that were submitted within a date range. */
	SELECT COUNT(te.EntryID)
	  FROM dbo.ThreadEntries te WITH (NOLOCK)
			INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = te.UserID
			INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = te.ForumID
			INNER JOIN dbo.Threads t WITH (NOLOCK) ON te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID
	 WHERE t.Type = 'Notice'
	   AND f.SiteID = @siteid
	   AND te.Parent is not null 
	   AND te.DatePosted BETWEEN @startdate AND @enddate
	   AND u.Status = 1 
	   AND NOT EXISTS (SELECT 1
						 FROM dbo.GroupMembers gm
						WHERE gm.UserID = u.UserID
						  AND gm.SiteID = @siteid
						  AND gm.GroupID IN (8, 198, 205, 207, 214)) 
RETURN @@ERROR 