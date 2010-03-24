CREATE PROCEDURE updatethreadpostings 
AS

BEGIN TRANSACTION
DECLARE @ErrorCode INT

delete from ThreadPostings
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
							LastUserPostID, ForumID, Replies, CountPosts)
	SELECT t1.UserID, t1.ThreadID, t2.LastPosting, t1.UserLastPosting, 
			t1.UserLastPostID, t3.ForumID, 
			'Replies' = CASE WHEN t2.LastPosting > t1.UserLastPosting THEN 1 ELSE 0 END, 
			t2.Cnt  
	FROM (SELECT ThreadID, UserID, 'UserLastPosting' = MAX(DatePosted), 'UserLastPostID' = MAX(EntryID) 
			FROM ThreadEntries 
			WHERE (Hidden IS NULL)
			GROUP BY ThreadID, UserID) As t1
		INNER JOIN (SELECT ThreadID, 'LastPosting' = MAX(DatePosted), 'Cnt' = COUNT(*) 
						FROM ThreadEntries
						WHERE (Hidden IS NULL)
						GROUP BY ThreadID) As t2 ON t1.ThreadID = t2.ThreadID
		INNER JOIN Threads t3 ON t1.ThreadID = t3.ThreadID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
