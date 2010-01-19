CREATE PROCEDURE deletetextboxelement @textboxelementid int, @userid INT
AS
-- Check to make sure we're actually going to delete something!
IF NOT EXISTS ( SELECT * FROM dbo.TextBoxElements WHERE TextBoxElementID = @textboxelementid )
BEGIN
	SELECT 'ValidID' = 0
	RETURN 0
END

-- Get the current status of the Element, and work out the correct new status
DECLARE @Error int, @Status int, @NewStatus int, @LinkElementID int, @ElementID int
SELECT @ElementID = te.ElementID, @Status = fpe.ElementStatus, @LinkElementID = fpe.ElementLinkID FROM dbo.FrontPageElements fpe
INNER JOIN dbo.TextBoxElements te ON te.ElementID = fpe.ElementID
WHERE te.TextBoxElementID = @textboxelementid


-- Now call the internal delete procedure
DECLARE @ValidID int
BEGIN TRANSACTION
	EXEC @Error = DeleteFrontPageElementInternal @ElementID, @Status, @LinkElementID, @userID, @ValidID OUTPUT
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION
SELECT 'ValidID' = @ValidID