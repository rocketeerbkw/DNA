CREATE Procedure getuserstats2 @userid int
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

CREATE TABLE #stats
(	Category varchar(50),
	h2g2ID int,
	ForumID int,
	ThreadID int,
	Subject varchar(255),
	Date datetime,
	Newer datetime,
	Replies int,
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
	SELECT DISTINCT TOP 5	'Category' = 'Guide Entries',
					'h2g2ID' = g.h2g2ID,
					'ForumID' = NULL,
					'ThreadID' = NULL,
					'Subject' = CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END,
					'Date' = g.DateCreated,
					NULL,
					NULL,
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
	SELECT DISTINCT TOP 5	'Category' = 'User Pages',
					'h2g2ID' = h2g2ID,
					'ForumID' = NULL,
					'ThreadID' = NULL,
					'Subject' = CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END,
					'Date' = DateCreated,
					NULL,
					NULL,
					'Status' = g.Status,
					'OrdNum' = 2 
		FROM GuideEntries g
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		INNER JOIN Users u ON u.UserID = @userid
		WHERE ((g.Status >= 3 AND g.Status < 7)  OR (g.Status >10)) AND NOT EXISTS (select * from Mastheads where UserID = u.UserID and SiteID = g.SiteID)
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
	SELECT TOP 10	'Category' = 'Forum Entries',
					'h2g2ID' = NULL,
					'ForumID' = t.ForumID, 
					'ThreadID' = c.ThreadID, 
					'Subject' = CASE WHEN t.FirstSubject = '' THEN 'No Subject' ELSE t.FirstSubject END, 
					'Date' = c.MostRecent, 
					'Newer' = c1.LastReply, 
					'Replies' = CASE 
									WHEN c.MostRecent >= c1.LastReply 
									THEN 0 
									ELSE 1 
								END,
					'Status' = NULL,
					'OrdNum' = 1 
			FROM Threads t
			INNER JOIN (SELECT ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
			WHERE UserID = @userid AND (Hidden IS NULL)
			GROUP BY ThreadID) AS c ON c.ThreadID = t.ThreadID
			INNER JOIN (SELECT ThreadID, 'LastReply' = MAX(DatePosted) FROM ThreadEntries
			WHERE Hidden IS NULL
			/* WHERE DatePosted > @after AND DatePosted < @before */
			GROUP BY ThreadID) AS c1 ON c1.ThreadID = t.ThreadID
			/*INNER JOIN Users u ON u.UserID = @userid */
			ORDER BY /*Replies DESC,*/ c1.LastReply DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

SELECT * FROM #stats
ORDER BY OrdNum/* , Date DESC */
DROP TABLE #stats
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)


