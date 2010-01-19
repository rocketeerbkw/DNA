CREATE PROCEDURE getmbstatsmodstatstopictotals @siteid int, @date datetime
AS

DECLARE @Today DATETIME, @Day DATETIME, @NextDay DATETIME

-- Snap date to the midnight on the given day
SET @Day = dbo.udf_snapdate(@date,'day')
SET @Today = dbo.udf_snapdate(getdate(),'day')

IF @Day >= @Today
BEGIN
	RAISERROR ('getmbstatsmodstatstopictotals can only be called with a date from yesterday or earlier',16,1)
	RETURN 50000
END

-- Work out the next day's date
SET @NextDay = DATEADD(day,1,@Day)

IF NOT EXISTS(SELECT * FROM MBStatsModStatsTopicTotals WITH(NOLOCK) WHERE SiteID=@siteid AND Day=@Day)
BEGIN
	INSERT INTO MBStatsModStatsTopicTotals (SiteID, Day, TopicTitle, ForumID, StatusID, Status, Total)
		SELECT @siteid, @Day, g.subject, tm.forumid, tm.status, ms.status, count(*) FROM topics t WITH(NOLOCK)
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.h2g2id=t.h2g2id
			INNER JOIN ThreadMod tm WITH(NOLOCK) ON tm.forumid = g.forumid
			INNER JOIN ModStatus ms WITH(NOLOCK) ON ms.statusid=tm.status
			WHERE t.siteid=@siteid AND tm.DateQueued >= @Day AND tm.DateQueued < @NextDay
			GROUP BY g.subject, tm.forumid, tm.status, ms.status
END

SELECT SiteID, Day, TopicTitle, ForumID, StatusID, Status, Total
	FROM MBStatsModStatsTopicTotals WITH(NOLOCK)
	WHERE SiteID=@siteid AND Day=@Day
	ORDER BY TopicTitle,Status