CREATE PROCEDURE getnumberofuserorganisedclubs @siteid INT, @startdate datetime, @enddate datetime
AS	
	/* Returns number of clubs that have at least one standard user as an organisor that were created in a given date range. */
	SELECT COUNT (DISTINCT c.ClubID)
	  FROM dbo.Clubs c WITH (NOLOCK)
		   INNER JOIN TeamMembers tm WITH (NOLOCK) ON tm.TeamID = c.OwnerTeam
		   INNER JOIN Users u WITH (NOLOCK) ON u.UserID = tm.UserID
	 WHERE c.SiteID = @siteid
	   AND u.Status = 1
	   AND NOT EXISTS (SELECT 1
						 FROM dbo.GroupMembers gm WITH (NOLOCK)
						WHERE gm.UserID = u.UserID
						  AND gm.SiteID = @siteid
						  AND gm.GroupID in (8, 198, 205, 207, 214))
	   AND c.DateCreated BETWEEN @startdate AND @enddate

RETURN @@ERROR