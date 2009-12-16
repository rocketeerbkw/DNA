CREATE PROCEDURE getnumberofguideentrycomplaintsbystatus @siteid INT, @status INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns number of guide entry complaints with a given status within a date range.

		Params:
			@siteid - SiteID.
			@status - status of complaint. 
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS GuideEntryComplaintCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) AS 'GuideEntryComplaintCount'
	  FROM dbo.ArticleMod am WITH (NOLOCK)
	 WHERE am.SiteID = @siteid
	   AND am.Status = @status
	   AND DateQueued >= @startdate 
	   AND DateQueued < @enddate;

RETURN @@ERROR