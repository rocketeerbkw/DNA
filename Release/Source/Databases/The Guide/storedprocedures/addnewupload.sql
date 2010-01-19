CREATE PROCEDURE addnewupload  @teamid int,
								  @userid int,
								  @filename varchar(255),
								  @filetype int
AS
DECLARE @ErrorCode INT
BEGIN TRANSACTION

	INSERT INTO Uploads (TeamID, UserID, FileName, FileType)
	       VALUES       (@teamid, @userid, @filename, @filetype)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	declare @uploadid int
	SELECT @uploadid = @@IDENTITY

COMMIT TRANSACTION
Select 'Success' = 1, 'UploadID' = @uploadid
