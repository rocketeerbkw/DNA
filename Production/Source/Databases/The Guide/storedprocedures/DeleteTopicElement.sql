CREATE PROCEDURE deletetopicelement @topicelementid INT, @userid INT = 0
AS
-- Check to make sure we're actually going to delete something!
IF NOT EXISTS ( SELECT * FROM dbo.TopicElements WHERE TopicElementID = @topicelementid )
BEGIN
	-- It's vital that this doesn't return a result set when nested in another transaction
	-- If we create multiple result sets, but DNA doesn't process them, it can cause
	-- abnormal termination of the Stored Procedure (EventClass = Attention in SQL Profiler)
	IF @@TRANCOUNT < 1
	BEGIN	
		SELECT 'ValidID' = 0
	END
	
	RETURN 0
END

-- Get the current status of the Element, and work out the correct new status
DECLARE @Error int, @Status int, @NewStatus int, @LinkElementID int, @ElementID int
SELECT @ElementID = te.ElementID, @Status = fpe.ElementStatus, @LinkElementID = fpe.ElementLinkID FROM dbo.FrontPageElements fpe
INNER JOIN dbo.TopicElements te ON te.ElementID = fpe.ElementID
WHERE te.TopicElementID = @topicelementid


-- Now call the internal delete procedure
DECLARE @ValidID int
BEGIN TRANSACTION
	EXEC @Error = DeleteFrontPageElementInternal @ElementID, @Status, @LinkElementID,@userid, @ValidID OUTPUT
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION

IF @@TRANCOUNT < 1
BEGIN	
	SELECT 'ValidID' = @ValidID
END
	