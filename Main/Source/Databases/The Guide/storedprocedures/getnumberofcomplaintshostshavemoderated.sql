CREATE PROCEDURE getnumberofcomplaintshostshavemoderated @siteid INT, @startdate datetime, @enddate datetime 
AS
	/*
		Function: Returns the number of complaints hosts have dealt with

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: UserID INT (ID of host), Count INT

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @urlname varchar(100)
	SELECT @urlname=urlname FROM Sites WHERE SiteID=@siteid;

	SELECT @urlname AS UrlName ,h.UserID, count(tm.LockedBy) AS 'Count'
	  FROM dbo.VHosts h
			LEFT JOIN dbo.ThreadMod tm on h.UserID = tm.LockedBy -- LEFT join to include hosts that haven't moderated anything
			   AND tm.SiteID = @siteid
			   AND tm.DateCompleted >= @startdate 
			   AND tm.DateCompleted < @enddate
			   -- AND tm.DateReferred IS NOT NULL 
			   -- AND tm.ReferredBy IS NOT NULL -- if only referred items are needed uncomment these two lines back in. 
	 WHERE h.SiteID = @SiteID
	 GROUP BY h.UserID
	 ORDER BY UrlName, Count DESC, UserID

RETURN @@ERROR