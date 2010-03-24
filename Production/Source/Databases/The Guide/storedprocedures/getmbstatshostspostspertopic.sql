CREATE PROCEDURE getmbstatshostspostspertopic @siteid int, @date datetime
AS

DECLARE @Today DATETIME, @Day DATETIME, @NextDay DATETIME

-- Snap date to the midnight on the given day
SET @Day = dbo.udf_snapdate(@date,'day')
SET @Today = dbo.udf_snapdate(getdate(),'day')

IF @Day >= @Today
BEGIN
	RAISERROR ('getmbstatshostspostspertopic can only be called with a date from yesterday or earlier',16,1)
	RETURN 50000
END

-- Work out the next day's date
SET @NextDay = DATEADD(day,1,@Day)

DECLARE @EditorGroupID int
SELECT @EditorGroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Editor'

IF NOT EXISTS(SELECT * FROM MBStatsHostsPostsPerTopic WITH(NOLOCK) WHERE SiteID=@siteid AND Day=@Day)
BEGIN
	INSERT INTO MBStatsHostsPostsPerTopic (SiteID, Day, UserID, UserName, Email, TopicTitle, ForumID, Total)
		SELECT @siteid, @Day, u.userid, u.username, u.email, g.subject, te.forumid, count(*) FROM sites s WITH(NOLOCK)
			INNER JOIN GroupMembers gm WITH(NOLOCK) ON gm.SiteID = s.siteid AND gm.GroupID = @EditorGroupID AND gm.UserID <> s.AutoMessageUserID
			INNER JOIN Users u WITH(NOLOCK) ON u.Userid = gm.UserID
			INNER JOIN Topics t WITH(NOLOCK) ON t.siteid = s.siteid
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.h2g2id = t.h2g2id
			INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ForumID = g.ForumID AND te.userid=u.userid AND te.DatePosted >= @day and te.DatePosted < @nextday
			WHERE s.siteid=@siteid
			GROUP BY u.userid, u.username, u.email, g.subject, te.forumid
END

SELECT SiteID, Day, UserID, UserName, Email, TopicTitle, ForumID, Total
	FROM MBStatsHostsPostsPerTopic WITH(NOLOCK)
	WHERE SiteID = @siteid AND Day = @Day
	ORDER BY UserName, TopicTitle

