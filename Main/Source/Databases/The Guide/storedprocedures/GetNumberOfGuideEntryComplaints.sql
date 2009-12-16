CREATE PROCEDURE getnumberofguideentrycomplaints @siteid INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns the number of guide entry complaints within a date range.

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS GuideEntryComplaintCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) AS 'GuideEntryComplaintCount'
	  FROM dbo.ArticleMod WITH (NOLOCK)
	 WHERE SiteID = @siteid
	   AND DateQueued >= @startdate 
	   AND DateQueued < @enddate;


RETURN @@ERROR