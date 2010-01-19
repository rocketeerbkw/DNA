create procedure mediaassetuploadqueueadd @assetid int, @server varchar(50), @addtolibrary int = 0, @skipmoderation int = 0
as

BEGIN TRANSACTION 
	
	DECLARE @ErrorCode INT
	
	DECLARE @mimetype varchar(255)
	DECLARE @siteid INT

	SELECT @mimetype = MimeType, @siteid = SiteID FROM MediaAsset WHERE ID = @assetid
	
	INSERT MediaAssetUploadQueue (AssetID, MimeType, SiteID, InLibrary, SkipModeration, Server)
	VALUES (@assetid, @mimetype, @siteid, @addtolibrary, @skipmoderation, @server)
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
COMMIT TRANSACTION