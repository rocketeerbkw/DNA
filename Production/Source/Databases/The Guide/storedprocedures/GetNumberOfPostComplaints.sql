CREATE PROCEDURE getnumberofpostcomplaints @siteid INT, @startdate datetime, @enddate datetime
AS
	/*
		Function: Returns the number of complaints about Posts that have been submitted to the moderators within a date range.

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS PostComplaintCount

		Returns: @@ERROR
	*/
	SELECT COUNT(*) AS 'PostComplaintCount'
	  FROM dbo.ThreadMod WITH (NOLOCK)
	 WHERE SiteID = @siteid
	   AND DateCompleted >= @startdate 
	   AND DateCompleted < @enddate

RETURN @@ERROR