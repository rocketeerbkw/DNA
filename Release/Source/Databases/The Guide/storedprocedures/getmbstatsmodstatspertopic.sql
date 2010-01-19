CREATE PROCEDURE getmbstatsmodstatspertopic @siteid int, @date datetime
AS

DECLARE @Today DATETIME, @Day DATETIME, @NextDay DATETIME

-- Snap date to the midnight on the given day
SET @Day = dbo.udf_snapdate(@date,'day')
SET @Today = dbo.udf_snapdate(getdate(),'day')

IF @Day >= @Today
BEGIN
	RAISERROR ('getmbstatsmodstatspertopic can only be called with a date from yesterday or earlier',16,1)
	RETURN 50000
END

-- Work out the next day's date
SET @NextDay = DATEADD(day,1,@Day)

IF NOT EXISTS(SELECT * FROM MBStatsModStatsPerTopic WITH(NOLOCK) WHERE SiteID=@siteid AND Day=@Day)
BEGIN
	INSERT INTO MBStatsModStatsPerTopic (SiteID,Day,TopicTitle,ForumID,UserID,UserName,Email,StatusID,Status,Total)
		SELECT @siteid, @Day, g.subject, tm.forumid, u.userid, u.username, u.email, tm.status, ms.status, count(*) FROM Topics t WITH(NOLOCK)
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.h2g2id=t.h2g2id
			INNER JOIN ThreadMod tm WITH(NOLOCK) ON tm.forumid = g.forumid and tm.DateQueued >= @Day and tm.DateQueued < @NextDay
			INNER JOIN Users u WITH(NOLOCK) ON u.userid = tm.lockedby
			INNER JOIN ModStatus ms WITH(NOLOCK) ON ms.statusid=tm.status
			WHERE t.siteid=@siteid
			GROUP BY g.subject, tm.forumid, u.userid, u.username, u.email, tm.status, ms.status
END

SELECT SiteID, Day, TopicTitle, ForumID, UserID, UserName, Email, StatusID, Status, Total
	FROM MBStatsModStatsPerTopic WITH(NOLOCK)
	WHERE SiteID = @siteid AND Day = @Day
	ORDER BY TopicTitle,UserName,Status

