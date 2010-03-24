CREATE PROCEDURE makepreviewtextboxelementactive @textboxelementid int, @editorid int
AS
DECLARE @Error int, @LinkElementID int, @ElementID int, @ElementStatus int

declare @activetextboxid INT

-- Check to make sure the element is actually a preview
SELECT @ElementID = fpe.ElementID, @LinkElementID = fpe.ElementLinkID, @ElementStatus = fpe.ElementStatus FROM dbo.FrontPageElements fpe
INNER JOIN dbo.TextBoxElements te ON te.ElementID = fpe.ElementID
WHERE te.TextBoxElementID = @textboxelementid AND fpe.ElementStatus IN (1,4)

-- Check make sure the topic exists, and it hasn't been marked as deleted!
IF ( @ElementID IS NULL)
BEGIN
	RETURN 0
END

-- Check to see if it exists
BEGIN TRANSACTION
	IF ( @LinkElementID = 0 AND @ElementStatus = 1) -- Only create an active item if the current topic is a preview item!
	BEGIN
		-- We Need to create the active element
		INSERT INTO dbo.FrontPageElements
					(
						SiteID,
						ElementLinkID, 
						ElementStatus, 
						TemplateType, 
						FrontPagePosition, 
						Title, 
						Text, 
						TextBoxType, 
						TextBorderType, 
						ImageName, 
						EditKey, 
						ImageWidth,
						ImageHeight, 
						ImageAltText, 
						DateCreated, 
						LastUpdated, 
						UserID
					)
			SELECT	fpe.SiteID,
					fpe.ElementID,
					0, /* ES_LIVE*/
					fpe.TemplateType,
					fpe.FrontPagePosition,
					fpe.Title,
					fpe.Text,
					fpe.TextBoxType, 
					fpe.TextBorderType,
					fpe.ImageName,
					NewID(),
					fpe.ImageWidth,
					fpe.ImageHeight,
					fpe.ImageAltText, 
					CURRENT_TIMESTAMP 'DateCreated', 
					CURRENT_TIMESTAMP 'LastUpdated', 
					@editorid 'UserID'
			FROM dbo.FrontPageElements fpe
			WHERE fpe.ElementID = @ElementID
		SELECT @Error = @@ERROR
		SELECT @LinkElementID = @@IDENTITY
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		-- Update the preview link id
		UPDATE dbo.FrontPageElements SET ElementLinkID = @LinkElementID WHERE ElementID = @ElementID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		-- Create the Active TextBoxElement
		INSERT INTO dbo.TextBoxElements SELECT ElementID = @LinkElementID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		--Remove old key phrases associated with active item and copy key phrases from preview item.
		SET @activetextboxid = @@IDENTITY 
		insert into TextBoxElementKeyPhrases( textboxelementid, phraseid ) 
		(  select @activetextboxid 'textboxelementid', phraseid from TextBoxElementKeyPhrases where textboxelementid = @textboxelementid )
	END
	ELSE IF (@LinkElementID <> 0) -- There's already an active item, update it to match the preview item
	BEGIN
		-- Just copy the preview element info to the active element.
		UPDATE dbo.FrontPageElements
			SET	SiteID = fpe.SiteID,
				ElementStatus = CASE
						WHEN fpe.ElementStatus = 1	/*Preview*/
						THEN 0						/*Active*/
						ELSE 3						/*ActiveArchived*/
						END,
				TemplateType = fpe.TemplateType,
				FrontPagePosition = fpe.FrontPagePosition,
				Title = fpe.Title,
				[Text] = fpe.Text,
				TextBoxType = fpe.TextBoxType,
				TextBorderType = fpe.TextBorderType,
				ImageName = fpe.ImageName,
				ImageWidth = fpe.ImageWidth,
				ImageHeight  = fpe.ImageHeight,
				ImageAltText = fpe.ImageAltText,
				LastUpdated = CURRENT_TIMESTAMP,
				UserID = @editorid,
				EditKey = NewID()
		FROM (SELECT * FROM dbo.FrontPageElements WHERE ElementID = @ElementID) as fpe
		WHERE dbo.FrontPageElements.ElementID = @LinkElementID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		--Remove old key phrases associated with active item and copy key phrases from preview textbox to active text box.
		select @activetextboxid = textboxelementid from textboxelements where elementid = @LinkElementID
		delete from [dbo].TextBoxElementKeyPhrases where textboxelementid = @activetextboxid
		insert into TextBoxElementKeyPhrases( textboxelementid, phraseid ) 
		(  select @activetextboxid 'textboxelementid', phraseid from TextBoxElementKeyPhrases where textboxelementid = @textboxelementid )
	END
	ELSE
	BEGIN
		RETURN 0
	END
COMMIT TRANSACTION

