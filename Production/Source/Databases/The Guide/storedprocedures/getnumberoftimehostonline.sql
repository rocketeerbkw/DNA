CREATE PROCEDURE getnumberoftimehostonline @siteid INT, @startdate datetime, @enddate datetime 
AS
	/*
		Function: Returns approximate cumulative time hosts where active on site (in minutes).

		Params:
			@siteid - SiteID on which the host has posted.
			@startdate - Start of the date range
			@name - End of the date range i.e. first point outside the date range. 

		Results Set: UserID INT (ID of host), Minutes INT

		Returns: @@ERROR

		Notes: This stored procedure only returns approximate times given that the data in the Sessions table is not exactly when a user logged in and out. 
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @urlname varchar(100)
	SELECT @urlname=urlname FROM Sites WHERE SiteID=@siteid;

	WITH LoginSessions AS
	(
		SELECT h.UserID, 
			   CASE WHEN s.DateStarted < @startdate THEN @startdate ELSE s.DateStarted END AS 'StartDate', -- if the session started before the start of the search daterange then start counting from the start of the search date range.
			   CASE WHEN s.DateLastLogged > @enddate THEN @enddate ELSE s.DateLastLogged END AS 'EndDate' -- if the session ended after the start of the search daterange then stop counting from the end of the search date range.
		  FROM dbo.VHosts h
				LEFT JOIN dbo.Sessions s on h.UserID = s.UserID -- LEFT join to include hosts that haven't been online
					AND s.SiteID = @siteid
				   AND s.DateStarted < @enddate
				   AND s.DateLastLogged > @startdate -- session was within daterange
		 WHERE h.SiteID = @siteid
	)
	SELECT @urlname as UrlName, UserID, ISNULL(SUM(DATEDIFF(ss, StartDate, EndDate)) / 60,0) AS 'Minutes'
	  FROM LoginSessions
	 GROUP BY UserID
	 ORDER BY UrlName, Minutes DESC, UserID

RETURN @@ERROR
