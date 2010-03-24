CREATE PROCEDURE makepreviewtopicelementactive @topicelementid int, @editorid int
AS
DECLARE @Error int, @LinkElementID int, @ElementID int, @PreviewTopicID int, @ActiveTopicID int, @ElementStatus int

-- Check to make sure the element is actually a preview
SELECT @ElementID = fpe.ElementID, @LinkElementID = fpe.ElementLinkID, @PreviewTopicID = te.TopicID, @ElementStatus = fpe.ElementStatus FROM dbo.FrontPageElements fpe
INNER JOIN dbo.TopicElements te ON te.ElementID = fpe.ElementID
WHERE te.TopicElementID = @topicelementid AND fpe.ElementStatus IN (1,4)

-- Check make sure the topic exists, and it hasn't been marked as deleted!
IF ( @ElementID IS NULL OR @PreviewTopicID = 0)
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

		-- Create the Active TopicElement
		SELECT @ActiveTopicID = TopicLinkID FROM dbo.Topics WHERE TopicID = @PreviewTopicID
		INSERT INTO dbo.TopicElements SELECT ElementID = @LinkElementID, TopicID = @ActiveTopicID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
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
				ImageHeight = fpe.ImageHeight,
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
	END
	ELSE
	BEGIN
		RETURN 0
	END
COMMIT TRANSACTION
