CREATE PROCEDURE getclubtotalcampaignupdateslist @siteid INT
AS
	/* Return list of campaigns and the number of associated campaign updates. */

	SELECT c.ClubID, c.Name, COUNT (DISTINCT te.ThreadID)
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = c.Journal
			LEFT JOIN dbo.ThreadEntries te WITH (NOLOCK) ON te.ForumID = f.ForumID
	 WHERE c.SiteID = 16 -- @siteid
	   AND Parent IS NULL -- is a campaign update rather than a comment on a campaign update
	 GROUP BY c.ClubID, c.Name

RETURN @@ERROR