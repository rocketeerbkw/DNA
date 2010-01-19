CREATE PROCEDURE getnumberofpostcomplaintsbystatus @siteid INT, @status INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns the number of complaints about Posts with a given status that have been submitted to the moderators within a date range.

		Params:
			@siteid - SiteID.
			@status - status of complaint. 
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS PostComplaintCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) AS 'PostComplaintCount'
	  FROM dbo.ThreadMod
	 WHERE SiteID = @siteid
	   AND Status = @status
	   AND DateQueued >= @startdate 
	   AND DateQueued < @enddate;

RETURN @@ERROR