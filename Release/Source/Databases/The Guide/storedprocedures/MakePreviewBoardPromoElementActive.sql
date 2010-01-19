CREATE PROCEDURE makepreviewboardpromoelementactive @boardpromoelementid int, @editorid int
AS
DECLARE @Error int, @LinkElementID int, @ElementID int, @ElementStatus int, @ActiveBoardPromoID int

-- Check to make sure the element is actually a preview
SELECT @ElementID = fpe.ElementID, @LinkElementID = fpe.ElementLinkID, @ElementStatus = fpe.ElementStatus FROM dbo.FrontPageElements fpe
INNER JOIN dbo.BoardPromoElements bpe ON bpe.ElementID = fpe.ElementID
WHERE bpe.BoardPromoElementID = @boardpromoelementid AND fpe.ElementStatus IN (1,4)

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

		-- Create the Active BoardProElement
		INSERT INTO dbo.BoardPromoElements SELECT ElementID = @LinkElementID, [Name] = 'New'
		SELECT @Error = @@ERROR
		SELECT @ActiveBoardPromoID = @@IDENTITY
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		-- Now update the active topic that this new promo belongs to, if any!
		UPDATE dbo.Topics SET BoardPromoID = @ActiveBoardPromoID--@LinkElementID
		FROM
		(
			SELECT TopicLinkID FROM dbo.Topics
			WHERE BoardPromoID = @boardpromoelementid
		) AS t1
		WHERE dbo.Topics.TopicID = t1.TopicLinkID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		--Copy any key phrases associated with the preview board promo.
		insert into BoardPromoElementKeyPhrases( boardpromoelementid, phraseid ) 
		(  select @ActiveBoardPromoID 'boardpromoelementid', phraseid from BoardPromoElementKeyPhrases where boardpromoelementid = @boardpromoelementid )
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

		UPDATE dbo.BoardPromoElements SET [Name] = bpe.[Name]
			FROM (SELECT [Name] FROM dbo.BoardPromoElements WHERE ElementID = @ElementID) as bpe
			WHERE dbo.BoardPromoElements.ElementID = @LinkElementID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		-- Now update the active topic that this new promo belongs to, if any!
		SELECT @ActiveBoardPromoID = bpe.BoardPromoElementID FROM dbo.BoardPromoElements bpe
		INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID
		WHERE fpe.ElementID = @LinkElementID
		UPDATE dbo.Topics SET BoardPromoID = @ActiveBoardPromoID
		FROM
		(
			SELECT TopicLinkID FROM dbo.Topics
			WHERE BoardPromoID = @boardpromoelementid
		) AS t1
		WHERE dbo.Topics.TopicID = t1.TopicLinkID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		--Remove old key phrases associated with active item and copy key phrases from preview item.
		delete from [dbo].BoardPromoElementKeyPhrases where boardpromoelementid = @ActiveBoardPromoID
		insert into BoardPromoElementKeyPhrases( boardpromoelementid, phraseid ) 
		(  select @ActiveBoardPromoID 'boardpromoelementid', phraseid from BoardPromoElementKeyPhrases where boardpromoelementid = @boardpromoelementid )
	END

COMMIT TRANSACTION
