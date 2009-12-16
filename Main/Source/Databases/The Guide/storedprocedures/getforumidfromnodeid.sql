CREATE PROCEDURE getforumidfromnodeid @inodeid int, @isiteid int
As
SELECT * FROM GuideEntries WHERE h2g2ID IN
(
	SELECT h2g2ID FROM Hierarchy WHERE NodeID = @inodeid AND SiteID = @isiteid
)
