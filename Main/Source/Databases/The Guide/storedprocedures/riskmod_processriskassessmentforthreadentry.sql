CREATE PROCEDURE riskmod_processriskassessmentforthreadentry @riskmodthreadentryqueueid int, @risky bit, @newthreadentryid int OUTPUT
AS

-- IMPORTANT.  This SP should not use WITH(NOLOCKS) as it's designed to block while the tables it accesses are being changed

BEGIN TRY
	BEGIN TRANSACTION
	
	DECLARE @ForumId int, @ThreadId int, @SiteId int, @ThreadEntryId int, @PublishMethod char(1)
	
	-- Get some info about the RiskModThreadEntryQueue item
	SELECT @ForumId = rm.forumid, @ThreadId = rm.threadid, @SiteId = rm.siteid, @ThreadEntryId = rm.ThreadEntryId, @PublishMethod=rm.PublishMethod
		FROM dbo.RiskModThreadEntryQueue rm WITH(UPDLOCK)
		WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid

	-- Update the IsRisky field to record the decision
	UPDATE dbo.RiskModThreadEntryQueue SET IsRisky=@risky WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid

	DECLARE @ErrorCode int
	
	IF @risky = 1
	BEGIN
		-- RISKY!
		IF @PublishMethod='B'
		BEGIN
			-- It's risky, so queue it for moderation
			EXEC QueueThreadEntryForModeration @ForumId, @ThreadId, @ThreadEntryId, @SiteId, '[The post was published before being queued by risk moderation]'
		END
		ELSE IF @PublishMethod='A'
		BEGIN
			-- It's risky and not yet published.
			-- In this case post it just like a premoderated post using premod posting
			EXEC @ErrorCode = riskmod_postriskmodthreadentrytoforum @riskmodthreadentryqueueid, /*@forcepremodposting*/ 1, '[The post will be published after moderation. Queued by risk moderation]', @newthreadentryid OUTPUT
		END
	END
	ELSE
	BEGIN
		-- Not risky
		IF @PublishMethod='B'
		BEGIN
			-- The post was published before risk assessment, so just return
			GOTO ReturnOk
		END
		ELSE IF @PublishMethod='A'
		BEGIN
			-- We need to publish this now that it's been assessed and it's not risky
			EXEC @ErrorCode = riskmod_postriskmodthreadentrytoforum @riskmodthreadentryqueueid, /*@forcepremodposting*/ 0, NULL, @newthreadentryid OUTPUT
		END
	END

	IF @ErrorCode > 0
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Unknown error' As ErrorMessage
		RETURN @ErrorCode
	END

ReturnOk:
	COMMIT TRANSACTION
	RETURN 0

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT ERROR_MESSAGE() As ErrorMessage
	RETURN ERROR_NUMBER()
END CATCH