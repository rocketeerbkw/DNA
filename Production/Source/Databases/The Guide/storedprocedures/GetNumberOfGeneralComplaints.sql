CREATE PROCEDURE getnumberofgeneralcomplaints @siteid INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns the number of general complaints on a site within a date range.

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS GeneralComplaintCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) AS 'GeneralComplaintCount'
	  FROM dbo.GeneralMod WITH (NOLOCK)
	 WHERE SiteID = @siteid
	   AND DateQueued >= @startdate 
	   AND DateQueued < @enddate;

RETURN @@ERROR
