-- IMPORTANT: @testdate should only be supplied for testing only

CREATE PROCEDURE setforumsactivestatus @testdate datetime=null, @active TinyInt, @f0 int, @f1 int = NULL, @f2 int = NULL, @f3 int = NULL, @f4 int = NULL,
						@f5 int = NULL, @f6 int = NULL, @f7 int = NULL, @f8 int = NULL, @f9 int = NULL,
						@f10 int = NULL, @f11 int = NULL, @f12 int = NULL, @f13 int = NULL, @f14 int = NULL,
						@f15 int = NULL, @f16 int = NULL, @f17 int = NULL, @f18 int = NULL, @f19 int = NULL

AS
DECLARE @Error int
BEGIN TRANSACTION

	IF (@active = 0)
	BEGIN
		-- When shutting the events down, we must run RunScheduledForumEvents just in case it's not been run yet.
		-- The code relies on all the events that should have been run today have already been run
		EXEC RunScheduledForumEvents @testdate
	END

	-- Update the forum entries in the ForumScheduledEvents table
	UPDATE ForumScheduledEvents SET Active = @active
	WHERE ForumID IN
	(
		@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
		@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
	)
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Set the correct state for the forums depending on the active flag!
	IF (@active = 0)
	BEGIN
		-- Put the next run date back so we know that they need to be run again if need
		DECLARE @Date DateTime
		SELECT @Date = ISNULL(@testdate,GetDate())

		-- Work out what day it is		
		DECLARE @today int
		SELECT @Today = CASE
			WHEN DATENAME(w,@Date) = 'Monday' THEN 0
			WHEN DATENAME(w,@Date) = 'Tuesday' THEN 1
			WHEN DATENAME(w,@Date) = 'Wednesday' THEN 2
			WHEN DATENAME(w,@Date) = 'Thursday' THEN 3
			WHEN DATENAME(w,@Date) = 'Friday' THEN 4
			WHEN DATENAME(w,@Date) = 'Saturday' THEN 5
			ELSE 6
		END
	
		-- Update events that may have run today - i.e. all events scheduled for today
		UPDATE ForumScheduledEvents
			SET NextRun = CASE
				-- For weekly events that run today, move them back in time
				WHEN DayType < 7 AND DayType = @Today THEN DATEADD(DAY,-7,NextRun)
				-- For daily events, move them back in time
				WHEN DayType = 7 THEN DATEADD(DAY,-1,NextRun)
				-- Otherwise don't change anything
				ELSE NextRun
			END,
			LastRun = CASE
				WHEN EventType = 0 THEN NULL
				ELSE LastRun
			END
			WHERE (NextRun >= @Date OR EventType = 0) AND ForumID IN
			(
				@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
				@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
			)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		-- Just close all the forums!
		UPDATE Forums SET CanWrite = 0, ThreadCanWrite = 0
		WHERE ForumID IN
		(
			@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
			@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
		)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		UPDATE Threads SET CanWrite = 0
		WHERE ForumID IN
		(
			@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
			@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
		)
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
		EXEC RunScheduledForumEvents @testdate
	END
COMMIT TRANSACTION
