CREATE PROCEDURE resetmailing	@shotid int
AS
DECLARE @listid int

SELECT @listid = ListID FROM Mailshots WHERE ShotID = @shotid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM SendRequests WHERE ShotID = @shotid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO SendRequests (ShotID, UserID)
	SELECT @shotid, UserID FROM Membership WHERE ListID = @listid AND Cancelled <> 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE MailShots SET Status = 0, TotalSent = 0, TotalToSend = (SELECT COUNT(ShotID) FROM SendRequests WHERE ShotID = @shotid)
	WHERE ShotID = @shotid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
