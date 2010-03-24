CREATE PROCEDURE getnumberoffailedposts @siteid INT, @startdate datetime, @enddate datetime 
AS
	/*
		Function: Returns the number of posts that were failed within a date range.

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS FailedPostCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) AS 'FailedPostCount'
	  FROM dbo.ThreadMod
	 WHERE SiteID = @siteid
	   AND DateCompleted >= @startdate 
	   AND DateCompleted < @enddate
	   AND (Status = 4 OR Status = 6) -- Failed

RETURN @@ERROR