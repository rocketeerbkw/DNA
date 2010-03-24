CREATE PROCEDURE getnumberofuserstosubmitcampaignlinks @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns number of users that have submitted campaign links. */
	SELECT COUNT(DISTINCT l.SubmitterID) -- SubmitterID missing in links table for many clublinks. Possible legacy bug. 
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.Links l WITH (NOLOCK) ON l.SourceID = c.ClubID AND l.SourceType = 'club' AND l.Relationship = 'clublink'
			INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = l.SubmitterID 
			LEFT JOIN dbo.GroupMembers gm WITH (NOLOCK) ON gm.UserID = u.UserID AND gm.SiteID = @siteid AND gm.GroupID NOT IN (8, 198, 205, 207, 214)
	 WHERE c.SiteID = @siteid
	   AND l.DateLinked BETWEEN @startdate AND @enddate

RETURN @@ERROR