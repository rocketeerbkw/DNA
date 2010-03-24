CREATE PROCEDURE getroute @routeid int, @siteid int
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT	r.RouteID, 
			r.UserID, 
			r.SiteID, 
			r.Title AS 'RouteTitle', 
			r.Description AS 'RouteDescription', 
			r.EntryID,
			ge.H2G2ID,
			ge.Subject
	FROM	dbo.Route r 
	LEFT JOIN dbo.GuideEntries ge on ge.EntryID = r.EntryID
	WHERE	r.RouteID = @routeid AND r.SiteID = @siteid

	SELECT	rl.LocationID,
			rl.[order], 
			l.Latitude, 
			l.Longitude, 
			l.Title AS 'LocationTitle', 
			l.Description AS 'LocationDescription', 
			l.DateCreated AS 'LocationDateCreated', 
			l.ZoomLevel AS 'LocationZoomLevel', 
			l.UserID AS 'LocationUserID'
	FROM	dbo.RouteLocation rl
	INNER JOIN dbo.Location l on l.LocationID = rl.LocationID
	WHERE	rl.RouteID = @routeid
	ORDER BY rl.[order]

RETURN @@ERROR
