CREATE PROCEDURE updateboardpromoelement	@boardpromoelementid int, @boardname varchar(256) = NULL, @templatetype int = NULL, @textboxtype int = NULL,
											@textbordertype int = NULL, @frontpageposition int = NULL, @elementstatus int = NULL, @elementlinkid int = NULL,
											@title varchar(256) = NULL, @text text = NULL, @imagename varchar(256) = NULL, @imagealttext varchar(256) = NULL,
											@applytemplatetoallinsite int = 0, @imagewidth int = NULL, @imageheight int = NULL, @editorid INT, @editkey uniqueidentifier
AS
-- Check to make sure the ElementID given is valid!
DECLARE @ElementID int
SELECT @ElementID = ElementID FROM dbo.BoardPromoElements WHERE BoardPromoElementID = @boardpromoelementid
IF ( @ElementID IS NULL )
BEGIN
	SELECT 'ValidID' = 0
	RETURN 0
END

DECLARE @Error int

BEGIN TRANSACTION
	-- Now check to make sure the Editkeys match!
	DECLARE @CurrentKey uniqueidentifier
	SELECT @CurrentKey = EditKey FROM dbo.FrontPageElements
	WHERE ElementID = @ElementID
	IF (@CurrentKey != @editkey)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'ValidID' = 2
		RETURN 0
	END
	
	DECLARE @NewEditKey uniqueidentifier
	SET @NewEditKey = NEWID()
	
	UPDATE dbo.FrontPageElements
		SET dbo.FrontPageElements.TemplateType		= ISNULL(@templatetype,fpe.TemplateType),
			dbo.FrontPageElements.TextBoxType		= ISNULL(@textboxtype,fpe.TextBoxType),
			dbo.FrontPageElements.TextBorderType	= ISNULL(@textbordertype,fpe.TextBorderType),
			dbo.FrontPageElements.FrontPagePosition = ISNULL(@frontpageposition,fpe.FrontPagePosition),
			dbo.FrontPageElements.ElementStatus		= ISNULL(@elementstatus,fpe.ElementStatus),
			dbo.FrontPageElements.ElementLinkID		= ISNULL(@elementlinkid,fpe.ElementLinkID),
			dbo.FrontPageElements.Title				= ISNULL(@title,fpe.Title),
			dbo.FrontPageElements.[Text]			= ISNULL(@text,fpe.[Text]),
			dbo.FrontPageElements.ImageName			= ISNULL(@imagename,fpe.ImageName),
			dbo.FrontPageElements.ImageWidth		= ISNULL(@imagewidth,fpe.ImageWidth),
			dbo.FrontPageElements.ImageHeight		= ISNULL(@imageheight,fpe.ImageHeight),
			dbo.FrontPageElements.ImageAltText		= ISNULL(@imagealttext,fpe.ImageAltText),
			dbo.FrontPageElements.LastUpdated		= CURRENT_TIMESTAMP,
			dbo.FrontPageElements.UserId			= @editorid,
			dbo.FrontPageElements.EditKey			= @NewEditKey
		FROM dbo.FrontPageElements AS fpe
		WHERE fpe.ElementID = @ElementID AND ElementID = @ElementID
	
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	IF (@boardname IS NOT NULL)
	BEGIN
		UPDATE dbo.BoardPromoElements
			SET dbo.BoardPromoElements.Name = @boardname
			WHERE BoardPromoElementID = @boardpromoelementid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END
	
	IF (@applytemplatetoallinsite = 1 AND ISNULL(@templatetype, 0) > 0 )
	BEGIN
		UPDATE dbo.FrontPageElements
			SET TemplateType = ISNULL(@templatetype,fpe.TemplateType)
			FROM dbo.FrontPageElements AS fpe
			WHERE SiteID = (SELECT SiteID FROM dbo.FrontPageElements WHERE ElementID = @ElementID)
		SELECT @Error = @@ERROR	
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END
COMMIT TRANSACTION

SELECT 'ValidID' = 1,'NewEditKey' = @NewEditKey
