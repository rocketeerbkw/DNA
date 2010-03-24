CREATE PROCEDURE getnumberofgeneralcomplaintsbystatus @siteid INT, @status INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns the number of general complaints with a given status on a site within a date range.

		Params:
			@siteid - SiteID.
			@status - status of complaint. 
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS GeneralComplaintCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT count(*) AS 'GeneralComplaintCount'
	  FROM dbo.GeneralMod gm
	 WHERE gm.SiteID = @siteid
	   AND gm.Status = @status
	   AND gm.DateQueued >= @startdate 
	   AND gm.DateQueued < @enddate;


RETURN @@ERROR 