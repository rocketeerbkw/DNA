CREATE PROCEDURE getguideentrylocation @h2g2id int
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT	al.LocationID, ge.h2g2id, l.SiteID, l.Latitude, l.Longitude, l.Title, l.Description
	  FROM	dbo.GuideEntries ge 
			LEFT JOIN dbo.ArticleLocation al on ge.EntryID = al.EntryID
			LEFT JOIN dbo.Location l on l.LocationID = al.LocationID
	 WHERE	ge.h2g2ID = @h2g2id

RETURN @@ERROR
