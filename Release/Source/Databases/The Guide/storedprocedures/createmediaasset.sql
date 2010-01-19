/*********************************************************************************

	create procedure createmediaasset @siteid int = 1, 
										@caption varchar(255) = "No Caption",
										@filename varchar(255) = NULL,
										@contenttype int = 1,
										@mimetype varchar(255) = NULL,
										@extraelementxml text = NULL,
										@ownerid int = 1

	Author:		Steven Francis
	Created:	17/10/2005
	Inputs:		Asset inforamtion
	Outputs:	Returns the AssetID
	Purpose:	Create a new Asset info
	
*********************************************************************************/

CREATE PROCEDURE createmediaasset	@siteid int = 1, 
									@caption varchar(255) = "No Caption",
									@filename varchar(255) = NULL,
									@contenttype int = 1,
									@mimetype varchar(255) = NULL,
									@extraelementxml text = NULL,
									@ownerid int = 1
As

BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	DECLARE @mediaassetid INT
	
	DECLARE @NowDateTime DATETIME
	
	SET @NowDateTime = GetDate()

	INSERT INTO MediaAsset (	SiteID, 
								Caption, 
								Filename,
								MimeType,
								ContentType, 
								ExtraElementXML, 
								OwnerID, 
								DateCreated,
								LastUpdated
							)
					VALUES(	@siteid,
							@caption,
							@filename,
							@mimetype,
							@contenttype,
							@extraelementxml,
							@ownerid,
							@NowDateTime,
							@NowDateTime
							)
							
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @mediaassetid = @@IDENTITY
	
COMMIT TRANSACTION

SELECT 'MediaAssetID' = @mediaassetid, 'DateCreated' = @NowDateTime, 'LastUpdated' = @NowDateTime

RETURN (0)