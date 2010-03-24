CREATE PROCEDURE getnumberofusercampaignupdates @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of user submitted campaign updates within a date range. */
	SELECT COUNT (DISTINCT te.ThreadID)
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = c.Journal
			LEFT JOIN dbo.ThreadEntries te WITH (NOLOCK) ON te.ForumID = f.ForumID
			INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = te.UserID AND u.Status = 1
			LEFT JOIN dbo.GroupMembers gm WITH (NOLOCK) ON gm.UserID = u.UserID AND gm.SiteID = @siteid AND gm.GroupID NOT IN (8, 198, 205, 207, 214)
	 WHERE c.SiteID = @siteid
	   AND te.Parent IS NULL -- is a campaign update rather than a comment on a campaign update
	   AND te.DatePosted BETWEEN @startdate AND @enddate

RETURN @@ERROR