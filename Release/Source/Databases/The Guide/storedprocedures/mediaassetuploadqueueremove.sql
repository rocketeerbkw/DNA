create procedure mediaassetuploadqueueremove @assetid int
as
BEGIN TRANSACTION
	
	DECLARE @ErrorCode INT
	
	DELETE FROM MediaAssetUploadQueue 
	WHERE AssetID = @assetid
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
COMMIT TRANSACTION