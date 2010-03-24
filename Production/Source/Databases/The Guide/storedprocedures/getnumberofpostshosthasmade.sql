CREATE PROCEDURE getnumberofpostshosthasmade @siteid INT, @startdate datetime, @enddate datetime 
AS
	/*
		Function: Returns the number of posts hosts have made on a site.

		Params:
			@siteid - SiteID on which the host has posted.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: UserID INT (ID of host), PostCount INT

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @urlname varchar(100)
	SELECT @urlname=urlname FROM Sites WHERE SiteID=@siteid

	SELECT te.EntryID,te.DatePosted INTO #e1
	  FROM dbo.VHosts h
			INNER JOIN dbo.ThreadEntries te ON h.UserID = te.UserID
	  WHERE h.SiteID = @siteid 

	SELECT te.UserID, count(*) AS 'PostCount' INTO #e2
	  FROM #e1
			INNER JOIN dbo.ThreadEntries te on #e1.EntryID = te.EntryID
			INNER JOIN dbo.Forums f on te.ForumID = f.ForumID
	  WHERE f.SiteID = @siteid
	   AND #e1.DatePosted >= @startdate
	   AND #e1.DatePosted < @enddate
	  GROUP BY te.UserID
	  ORDER BY UserID

	-- UNION in all the hosts that haven't posted
	SELECT @urlname AS UrlName, UserID, PostCount FROM #e2
	UNION
	SELECT @urlname AS UrlName, UserID, 0 FROM dbo.VHosts h
	  WHERE h.SiteID = @siteid AND h.UserID NOT IN (SELECT UserID FROM #e2)
	  ORDER BY PostCount DESC, UserID

RETURN @@ERROR
