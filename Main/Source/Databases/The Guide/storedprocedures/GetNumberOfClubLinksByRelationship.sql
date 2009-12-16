CREATE PROCEDURE getnumberofclublinksbyrelationship @siteid INT, @relationship varchar(30)
AS
	/* Return the number of club links by relationship e.g. the number of support articles. */
	SELECT c.ClubID, c.Name, COUNT(l.LinkID)
	  FROM dbo.Clubs c WITH (NOLOCK)
		   LEFT JOIN dbo.Links l WITH (NOLOCK) ON l.SourceID = c.ClubID AND l.SourceType = 'club' AND l.Relationship = @relationship
	 WHERE c.SiteID = @siteid
	 GROUP BY c.ClubID, c.Name

RETURN @@ERROR