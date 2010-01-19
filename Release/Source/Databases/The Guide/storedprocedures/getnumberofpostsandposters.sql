CREATE PROCEDURE getnumberofpostsandposters @siteid INT, @startdate DATETIME, @enddate DATETIME
AS
	/*
		Function: Returns the number of posts on a site within the date range and the number of distinct users who submitted those posts. 

		Params:
			@siteid - SiteID.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: INT AS PostCount, INT AS AuthorCount

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

	SELECT COUNT(EntryID) AS 'PostCount', COUNT(DISTINCT UserID) AS 'AuthorCount'
	  FROM dbo.ThreadEntries te
			inner join dbo.Forums f ON te.ForumID = f.ForumID AND f.SiteID = @SiteID
	 WHERE te.DatePosted >= @startdate
	   AND te.DatePosted < @enddate;

RETURN @@ERROR