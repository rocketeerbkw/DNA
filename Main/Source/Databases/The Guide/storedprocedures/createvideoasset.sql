/*********************************************************************************

	create procedure createvideoasset	@siteid int = 1, 
										@caption varchar(255) = "No Caption",
										@filename varchar(255) = NULL,
										@extraelementxml text = NULL,
										@ownerid int = 1,
										@description text = NULL,
										@addtolibrary int = 0,
										@filesize int = 0,
										@ipaddress varchar(25) = null,
										@skipmoderation int = 0,
										@externallinkurl varchar(255) = NULL

	Author:		Steven Francis
	Created:	07/11/2005
	Inputs:		Media Asset information
	Outputs:	Returns the MediaAssetID, DateCreated and LastUpdated
	Purpose:	Create a new Media Asset and an entry in the Video Asset table
	
*********************************************************************************/

CREATE PROCEDURE createvideoasset	@siteid int = 1, 
									@caption varchar(255) = "No Caption",
									@filename varchar(255) = NULL,
									@mimetype varchar(255) = NULL,
									@extraelementxml text = NULL,
									@ownerid int = 1,
									@description text = NULL,
									@addtolibrary int = 0,
									@filesize int = 0,
									@ipaddress varchar(25) = null,
									@skipmoderation int = 0,
									@externallinkurl varchar(255) = NULL
									
AS

BEGIN TRANSACTION

DECLARE @ErrorCode INT
DECLARE @MediaAssetID INT
DECLARE @DateCreated DATETIME
DECLARE @LastUpdated DATETIME

	EXEC @ErrorCode = dbo.createmediaassetinternal	@siteid, 
													@caption, 
													@filename,
													3, --ContentType
													@mimetype,
													@extraelementxml, 
													@ownerid,												
													@description,
													@filesize,
													@skipmoderation,
													@externallinkurl,
													@MediaAssetID OUTPUT,
													@DateCreated OUTPUT,
													@LastUpdated OUTPUT
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO dbo.VideoAsset (MediaAssetID) VALUES (@MediaAssetID)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END
	
	IF (@addtolibrary <> 0)
	BEGIN
		INSERT INTO dbo.MediaAssetLibrary (MediaAssetID) VALUES (@MediaAssetID)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @ErrorCode
		END
	END
	
	IF (@ipaddress IS NOT NULL)
	BEGIN
		INSERT INTO MediaAssetIPAddress (MediaAssetID, IPAddress) VALUES (@MediaAssetID, @ipaddress)
		-- No error checks.  Media Asset creation should not fail if this fails
	END
		
COMMIT TRANSACTION

SELECT 'MediaAssetID' = @MediaAssetID, 'DateCreated' = @DateCreated, 'LastUpdated' = @LastUpdated

