CREATE PROCEDURE getnumberofusercommentsoncampaignupdates @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of user comments on campaign updates within a date range. */
	SELECT COUNT (DISTINCT te.ThreadID)
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = c.Journal
			INNER JOIN dbo.ThreadEntries te WITH (NOLOCK) ON te.ForumID = f.ForumID
			INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = te.UserID	
	 WHERE c.SiteID = @siteid
	   AND te.Parent IS NOT NULL -- is a comment on a campaign update rather than a campaign update
	   AND te.DatePosted BETWEEN @startdate AND @enddate
	   AND u.Status = 1 
	   AND NOT EXISTS (SELECT 1
						 FROM dbo.GroupMembers gm
						WHERE gm.UserID = u.UserID
						  AND gm.SiteID = @siteid
						  AND gm.GroupID IN (8, 198, 205, 207, 214)) 
RETURN @@ERROR