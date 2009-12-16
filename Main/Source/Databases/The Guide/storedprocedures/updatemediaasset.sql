/*********************************************************************************

	create procedure updatemediaasset	@mediaassetid int = 1,
										@siteid int = 1, 
										@caption varchar(255) = "No Caption",
										@filename varchar(255) = NULL,
										@mimetype varchar(255) = NULL,
										@extraelementxml text = NULL,
										@ownerid int = 1
										@description text = NULL,
										@hidden int = 3,
										@externallinkurl varchar(255) = NULL

	Author:		Steven Francis
	Created:	17/10/2005
	Inputs:		Asset information
	Outputs:	
	Purpose:	updates the existing Asset info
				Adds in the external link url paramter for flickr youtube etc
	
*********************************************************************************/

CREATE PROCEDURE updatemediaasset	@mediaassetid int,
									@siteid int = 1, 
									@caption varchar(255) = "No Caption",
									@filename varchar(255) = NULL,
									@mimetype varchar(255) = NULL,
									@contenttype int = 1, 
									@extraelementxml text = NULL,
									@ownerid int = 1,
									@description text = NULL,
									@hidden int = 3,
									@externallinkurl varchar(255) = NULL

As

BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	
	DECLARE @NowDateTime DATETIME
	
	SET @NowDateTime = GetDate()

	IF @hidden = 0
	BEGIN
		SET @hidden = NULL
	END
		
	UPDATE MediaAsset SET	SiteID = @siteid, 
							Caption = @caption,
							Description = @description, 
							MimeType = @mimetype,
							ExtraElementXML = @extraelementxml, 
							OwnerID = @ownerid, 
							LastUpdated = @NowDateTime,
							Hidden = @hidden,
							ExternalLinkURL = @externallinkurl
	WHERE ID = @mediaassetid
							
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
COMMIT TRANSACTION

SELECT 'LastUpdated' = @NowDateTime, DateCreated FROM MediaAsset WHERE ID = @mediaassetid

RETURN (0)