CREATE Procedure newbinaryimage	@mimetype varchar(255), 
									@server varchar(255), 
									@path varchar(255),
									@name varchar(255),
									@desc varchar(255)
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

INSERT INTO blobs (mimetype, ServerName, Name, Description) 
	VALUES(@mimetype, @server, @name, @desc)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @blobid int
SELECT @blobid = @@IDENTITY
SELECT @path = @path + CAST(@blobid AS varchar(20))

UPDATE blobs SET Path = @path WHERE blobid = @blobid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

SELECT 'blobid' = @blobid, 'mimetype' = @mimetype, 'ServerName' = @server, 'Path' = @path
return (0)

