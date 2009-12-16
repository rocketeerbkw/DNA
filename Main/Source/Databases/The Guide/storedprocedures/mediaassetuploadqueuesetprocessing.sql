create procedure mediaassetuploadqueuesetprocessing @assetid int
as
BEGIN TRANSACTION
	
	DECLARE @ErrorCode INT
	
	UPDATE MediaAssetUploadQueue
		SET UploadStatus = 2
		where assetid=@assetid
		
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
COMMIT TRANSACTION