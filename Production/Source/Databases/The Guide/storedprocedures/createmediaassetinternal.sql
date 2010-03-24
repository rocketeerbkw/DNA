/*********************************************************************************

	create procedure createmediaassetinternal	@siteid int = 1, 
												@caption varchar(255) = "No Caption",
												@filename varchar(255) = NULL,
												@contenttype int = 1,
												@mimetype varchar(255) = NULL,
												@extraelementxml text = NULL,
												@ownerid int = 1,
												@description text = NULL,
												@filesize int = 0,
												@skipmoderation int = 0,
												@externallinkurl varchar(255) = NULL
												
	Author:		Steven Francis
	Created:	07/11/2005
	Inputs:		Asset information
	Outputs:	MediaAssetID, DateCreated, LastUpdated
	Purpose:	Create a new Asset info
	
*********************************************************************************/

CREATE PROCEDURE createmediaassetinternal	@siteid int = 1, 
											@caption varchar(255) = "No Caption",
											@filename varchar(255) = NULL,
											@contenttype int = 1,
											@mimetype varchar(255) = NULL,
											@extraelementxml text = NULL,
											@ownerid int = 1,
											@description text = NULL,
											@filesize int = 0,
											@skipmoderation int = 0,
											@externallinkurl varchar(255) = NULL,
											@MediaAssetID int OUTPUT,
											@DateCreated datetime OUTPUT,
											@LastUpdated datetime OUTPUT
As

IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('createmediaassetinternal cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

	DECLARE @ErrorCode INT
	
	DECLARE @Hidden INT
	
	IF @skipmoderation = 0
	BEGIN
		SET @Hidden = 3
	END
	ELSE
	BEGIN
		SET @Hidden = NULL
	END
	
	DECLARE @NowDateTime DATETIME
	
	SET @NowDateTime = GetDate()

	INSERT INTO dbo.MediaAsset (	SiteID, 
									Caption, 
									Filename,
									MimeType,
									ContentType, 
									ExtraElementXML, 
									OwnerID, 
									DateCreated,
									LastUpdated,
									Description,
									FileSize,
									Hidden,     --Create the asset with a default hidden = 3 so it will not appear in any searches
									            -- unless it's a super user and needs to skip moderation and appear immediately 
									            -- if so set to NULL
									ExternalLinkURL
								)
						VALUES(		@siteid,
									@caption,
									@filename,
									@mimetype,
									@contenttype,
									@extraelementxml,
									@ownerid,
									@NowDateTime,
									@NowDateTime,
									@description,
									@filesize,
									@Hidden,
									@externallinkurl
								)
							
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	SELECT @MediaAssetID = @@IDENTITY, @DateCreated = @NowDateTime, @LastUpdated = @NowDateTime
	
RETURN 0
