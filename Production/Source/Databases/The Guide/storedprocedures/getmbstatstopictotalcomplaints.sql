CREATE PROCEDURE getmbstatstopictotalcomplaints @siteid int, @date datetime
AS

DECLARE @Today DATETIME, @Day DATETIME, @NextDay DATETIME

-- Snap date to the midnight on the given day
SET @Day = dbo.udf_snapdate(@date,'day')
SET @Today = dbo.udf_snapdate(getdate(),'day')

IF @Day >= @Today
BEGIN
	RAISERROR ('getmbstatstopictotalcomplaints can only be called with a date from yesterday or earlier',16,1)
	RETURN 50000
END

-- Work out the next day's date
SET @NextDay = DATEADD(day,1,@Day)

IF NOT EXISTS(SELECT * FROM MBStatsTopicTotalComplaints WITH(NOLOCK) WHERE SiteID=@siteid AND Day=@Day)
BEGIN
	INSERT INTO MBStatsTopicTotalComplaints (SiteID, Day, ForumID, Total)
		SELECT @siteid, @Day, tm.forumid, count(*) FROM Topics t WITH(NOLOCK)
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.h2g2id=t.h2g2id
			INNER JOIN ThreadMod tm WITH(NOLOCK) ON tm.forumid = g.forumid AND tm.complaintText IS NOT NULL
			WHERE t.siteid=@siteid AND tm.DateQueued >= @Day AND tm.DateQueued < @NextDay
			GROUP BY tm.forumid
END

SELECT SiteID, Day, ForumID, Total
	FROM MBStatsTopicTotalComplaints WITH(NOLOCK)
	WHERE SiteID=@siteid AND Day=@Day
	ORDER BY ForumID