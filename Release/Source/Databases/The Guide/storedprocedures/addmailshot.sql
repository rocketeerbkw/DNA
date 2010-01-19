CREATE PROCEDURE addmailshot		@listid int,
					@fromname varchar(255),
					@fromaddress varchar(255),
					@mailname varchar(255),
					@subject varchar(255),
					@bodytext text
AS

BEGIN TRANSACTION
DECLARE @ErrorCode INT

INSERT INTO Mailshots (ListID, FromName, FromAddress, ShotName, Subject, Text)
	VALUES(@listid, @fromname, @fromaddress, @mailname, @subject, @bodytext)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @shotid int
SELECT @shotid = @@IDENTITY
EXEC @ErrorCode = resetmailing @shotid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
