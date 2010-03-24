Create Procedure updatesitestats
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM SiteStats
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO SiteStats (Valuename, Today)
	SELECT 'Total Registered Users',COUNT(*) FROM ActivityLog WHERE LogDate >= DATEADD(day,-1,getdate()) AND LogType = 'ACTI'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE SiteStats 
	SET Yesterday = (SELECT COUNT(*) FROM ActivityLog WHERE LogDate >= DATEADD(day,-2,getdate()) AND LogDate < DATEADD(day,-1,getdate()) AND LogType = 'ACTI'),
	TwoDaysAgo = (SELECT COUNT(*) FROM ActivityLog WHERE LogDate >= DATEADD(day,-3,getdate()) AND LogDate < DATEADD(day,-2,getdate()) AND LogType = 'ACTI'),
	ThisWeek = (SELECT COUNT(*) FROM ActivityLog WHERE LogDate >= DATEADD(day,-7,getdate()) AND LogType = 'ACTI'),
	SinceLaunch = (SELECT COUNT(*) FROM ActivityLog WHERE LogType = 'ACTI')
	WHERE Valuename = 'Total Registered Users'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO SiteStats (Valuename, Today)
	SELECT 'Article Views',COUNT(*) FROM ArticleViews WHERE DateViewed >= DATEADD(day,-1,getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE SiteStats 
	SET Yesterday = (SELECT COUNT(*) FROM ArticleViews WHERE DateViewed >= DATEADD(day,-2,getdate()) AND DateViewed < DATEADD(day,-1,getdate())),
	TwoDaysAgo = (SELECT COUNT(*) FROM ArticleViews WHERE DateViewed >= DATEADD(day,-3,getdate()) AND DateViewed < DATEADD(day,-2,getdate())),
	ThisWeek = (SELECT COUNT(*) FROM ArticleViews WHERE DateViewed >= DATEADD(day,-7,getdate())),
	SinceLaunch = (SELECT COUNT(*) FROM ArticleViews WHERE DateViewed >= '28 Apr 1999')
	WHERE Valuename = 'Article Views'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO SiteStats (Valuename, Today)
	SELECT 'Forum Posts',COUNT(*) FROM ThreadEntries WHERE DatePosted >= DATEADD(day,-1,getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE SiteStats 
	SET Yesterday = (SELECT COUNT(*) FROM ThreadEntries WHERE DatePosted >= DATEADD(day,-2,getdate()) AND DatePosted < DATEADD(day,-1,getdate())),
	TwoDaysAgo = (SELECT COUNT(*) FROM ThreadEntries WHERE DatePosted >= DATEADD(day,-3,getdate()) AND DatePosted < DATEADD(day,-2,getdate())),
	ThisWeek = (SELECT COUNT(*) FROM ThreadEntries WHERE DatePosted >= DATEADD(day,-7,getdate())),
	SinceLaunch = (SELECT COUNT(*) FROM ThreadEntries WHERE DatePosted >= '28 Apr 1999')
	WHERE Valuename = 'Forum Posts'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO SiteStats (Valuename, Today)
	SELECT 'Articles Created',COUNT(*) FROM GuideEntries WHERE DateCreated >= DATEADD(day,-1,getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE SiteStats 
	SET Yesterday = (SELECT COUNT(*) FROM GuideEntries WHERE DateCreated >= DATEADD(day,-2,getdate()) AND DateCreated < DATEADD(day,-1,getdate())),
	TwoDaysAgo = (SELECT COUNT(*) FROM GuideEntries WHERE DateCreated >= DATEADD(day,-3,getdate()) AND DateCreated < DATEADD(day,-2,getdate())),
	ThisWeek = (SELECT COUNT(*) FROM GuideEntries WHERE DateCreated >= DATEADD(day,-7,getdate())),
	SinceLaunch = (SELECT COUNT(*) FROM GuideEntries WHERE DateCreated >= '28 Apr 1999')
	WHERE Valuename = 'Articles Created'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

--SELECT * FROM SiteStats
return (0)