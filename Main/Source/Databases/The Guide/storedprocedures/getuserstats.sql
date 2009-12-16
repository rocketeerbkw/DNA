Create Procedure getuserstats @userid int
As
return (0)
/*
deprecated

BEGIN TRANSACTION
DECLARE @ErrorCode INT

CREATE TABLE #stats
(	Category varchar(50),
	h2g2ID int,
	ForumID int,
	ThreadID int,
	Subject varchar(255),
	Date datetime,
	Status int,
	OrdNum int
)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO #stats
	SELECT TOP 5	'Category' = 'Guide Entries',
					'h2g2ID' = g.h2g2ID,
					'ForumID' = NULL,
					'ThreadID' = NULL,
					'Subject' = CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END,
					'Date' = g.DateCreated,
					'Status' = g.Status,
					'OrdNum' = 3
		FROM GuideEntries g
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		WHERE Status = 1 
			AND (Editor = @userid OR r.UserID = @userid)
		ORDER BY DateCreated DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO #stats
	SELECT TOP 5	'Category' = 'User Pages',
					'h2g2ID' = h2g2ID,
					'ForumID' = NULL,
					'ThreadID' = NULL,
					'Subject' = CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END,
					'Date' = DateCreated,
					'Status' = g.Status,
					'OrdNum' = 2 
		FROM GuideEntries g
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		INNER JOIN Users u ON u.UserID = @userid
		WHERE g.Status >= 3 AND g.Status < 7 AND (u.Masthead <> g.h2g2ID OR u.Masthead IS NULL)
			AND (Editor = @userid OR r.UserID = @userid)
		ORDER BY DateCreated DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


INSERT INTO #stats
	SELECT TOP 5	'Category' = 'Forum Entries',
					'h2g2ID' = NULL,
					'ForumID' = ForumID,
					'ThreadID' = ThreadID,
					'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END,
					'Date' = DatePosted,
					'Status' = NULL,
					'OrdNum' = 1 
		FROM ThreadEntries
		WHERE UserID = @userid AND (Hidden IS NULL)
		ORDER BY DatePosted DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

SELECT * FROM #stats
ORDER BY OrdNum, Date DESC
DROP TABLE #stats
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)
*/