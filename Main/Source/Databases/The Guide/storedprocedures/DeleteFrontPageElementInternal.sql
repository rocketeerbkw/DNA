CREATE PROCEDURE deletefrontpageelementinternal @elementid int, @status int, @linkelementid int, @userid int, @validid int OUTPUT
AS
/*
	THESE ARE THE VALUES FOR THE DIFFERENT TYPES OF STATUS
	
	0 - Active
	1 - Preview
	2 - Deleted
	3 - ArchivedActive
	4 - ArchivedPreview
	
*/

-- Check to make sure we got valid params
IF (@elementid IS NULL)
BEGIN
	RAISERROR('NULL ElementID given to delete',16,1)
	SELECT @validid = 0
	RETURN 500000
END

-- Now check the status, as we need to make sure we set thing to the correct values
DECLARE @NewStatus int
IF (@status = 0)
BEGIN
	-- We can only archive active items
	SELECT @NewStatus = 3
END
ELSE IF (@status = 1)
BEGIN
	-- Check to see if the preview item has a link element as it'll need archiving if so
	SELECT @NewStatus = CASE WHEN @linkelementid = 0 THEN 2 ELSE 4 END
END
ELSE
BEGIN
	-- We're either already archived or deleted!
	SELECT @validid = 1
	RETURN 0
END

-- Do the update
BEGIN TRANSACTION
	DECLARE @Error int
	IF (@NewStatus = 2)
	BEGIN
		-- No Active part, We need want to make sure the element has default values ready for next use
		UPDATE FrontPageElements 
			SET ElementStatus = @NewStatus,
			ElementLinkID = 0,
			TemplateType = 0,
			FrontPagePosition = 0,
			Title = '',
			[Text] = '',
			TextBoxType = 0,
			TextBorderType = 0,
			ImageName = NULL,
			ImageAltText = NULL,
			ImageWidth = 0,
			ImageHeight = 0,
			LastUpdated = CURRENT_TIMESTAMP,
			DateCreated = NULL,
			UserID = @userid
			WHERE ElementID = @elementid
	END
	ELSE
	BEGIN
		-- Just update the status, updated and user info
		UPDATE FrontPageElements 
			SET ElementStatus = @NewStatus,
			LastUpdated = CURRENT_TIMESTAMP,
			UserID = @userid
			WHERE ElementID = @elementid
	END
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION

SELECT @validid = 1