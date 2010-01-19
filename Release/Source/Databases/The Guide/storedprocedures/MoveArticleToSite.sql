CREATE PROCEDURE movearticletosite @h2g2id INT, @newsiteid INT
AS

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE GuideEntries SET SiteID = @newsiteid, LastUpdated = GETDATE() WHERE h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE Forums SET SiteID = @newsiteid, LastUpdated = GETDATE() FROM Forums f INNER JOIN GuideEntries ge ON f.forumID = ge.forumID 
	WHERE ge.h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
	SELECT g.ForumID, getdate()
		FROM GuideEntries g
			WHERE g.h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END



COMMIT TRANSACTION