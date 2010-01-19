CREATE PROCEDURE getnumberofusersubmittedcampaignlinks @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns number of user submitted campaign links within a date range. */
	SELECT COUNT(l.LinkID)
	  FROM dbo.Clubs c
			LEFT JOIN dbo.Links l ON l.SourceID = c.ClubID AND l.SourceType = 'club' AND l.Relationship = 'clublink'
	 WHERE c.SiteID = @siteid
	   AND l.DateLinked BETWEEN @startdate AND @enddate

RETURN @@ERROR 