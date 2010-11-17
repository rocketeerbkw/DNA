CREATE PROCEDURE riskmod_processriskassessmentforthreadentry @riskmodthreadentryqueueid int, @risky bit
AS

-- IMPORTANT.  This SP should not use WITH(NOLOCKS) as it's designed to block while the tables it accesses are being changed

-- IMPORTANT:  As this SP calls other SPs, you can't use OUTPUT params or rely on the return code to inform
-- the caller of results and errors.  You have to use a result set.

BEGIN TRY

	-- If called again with an entry that's already been processes, just ignore the call
	IF EXISTS (SELECT * FROM dbo.RiskModThreadEntryQueue WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid AND IsRisky IS NOT NULL)
		RETURN

	BEGIN TRANSACTION
	
	DECLARE @ForumId int, @ThreadId int, @SiteId int, @ThreadEntryId int, @PublishMethod char(1)
	
	-- Get some info about the RiskModThreadEntryQueue item
	SELECT @ForumId = rm.forumid, @ThreadId = rm.threadid, @SiteId = rm.siteid, @ThreadEntryId = rm.ThreadEntryId, @PublishMethod=rm.PublishMethod
		FROM dbo.RiskModThreadEntryQueue rm WITH(UPDLOCK)
		WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid

	-- Update the IsRisky field to record the decision, and the date it happened
	UPDATE dbo.RiskModThreadEntryQueue SET IsRisky=@risky, DateAssessed = getdate()
		WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid

	DECLARE @ErrorCode INT
	
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
			EXEC @ErrorCode = riskmod_postriskmodthreadentrytoforum @riskmodthreadentryqueueid, /*@forcepremodposting*/ 1, '[The post will be published after moderation. Queued by risk moderation]'
		END
	END
	ELSE
	BEGIN
		-- Not risky
		IF @PublishMethod='B'
		BEGIN
			-- The post was published before risk assessment, so just return
			GOTO CommitAndReturn
		END
		ELSE IF @PublishMethod='A'
		BEGIN
			-- We need to publish this now that it's been assessed and it's not risky
			EXEC @ErrorCode = riskmod_postriskmodthreadentrytoforum @riskmodthreadentryqueueid, /*@forcepremodposting*/ 0, NULL
		END
	END

	IF @ErrorCode > 0
	BEGIN
		SELECT @ErrorCode AS OuterErrorCode, 'riskmod_postriskmodthreadentrytoforum returned an error' As OuterErrorMessage
		GOTO RollbackAndReturn
	END

CommitAndReturn:
    IF XACT_STATE() = 1
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION
	RETURN

END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS OuterErrorCode, ERROR_MESSAGE() As OuterErrorMessage
	GOTO RollbackAndReturn
END CATCH

RollbackAndReturn:
	-- Only rollback the transaction if there is one to rollback
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
	RETURN