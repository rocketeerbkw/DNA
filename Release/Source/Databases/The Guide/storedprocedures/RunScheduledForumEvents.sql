-- IMPORTANT: @testdate should only be supplied for testing only

CREATE PROCEDURE runscheduledforumevents @testdate datetime = null
AS
DECLARE @EventID int, @Error int, @Date DateTime, @Today tinyint
-- Get the current day type
SELECT @Date = ISNULL(@testdate,GetDate())
SELECT @Today = CASE
	WHEN DATENAME(w,@Date) = 'Monday' THEN 0
	WHEN DATENAME(w,@Date) = 'Tuesday' THEN 1
	WHEN DATENAME(w,@Date) = 'Wednesday' THEN 2
	WHEN DATENAME(w,@Date) = 'Thursday' THEN 3
	WHEN DATENAME(w,@Date) = 'Friday' THEN 4
	WHEN DATENAME(w,@Date) = 'Saturday' THEN 5
	ELSE 6
END

BEGIN TRANSACTION
-- Update the NextRun values for the active recursive events (i.e. EventType=1)
UPDATE dbo.ForumScheduledEvents
	SET NextRun = CASE 
	WHEN DayType < 7 AND DayType = @Today THEN
		-- When Today, make sure the NextRun date is "pulled" to today
		DATEADD(DAY,DATEDIFF(DAY,NextRun,@Date),NextRun)
	WHEN DayType < 7 THEN
		-- When on another day, make sure it's 7 days ahead of the last time it would have run
		DATEADD(DAY,DATEDIFF(DAY,NextRun,@Date) + 7 + (CAST(DayType AS int) - @Today),NextRun)
	ELSE
		-- It's a daily event, "pull" it to today
		DATEADD(DAY,DATEDIFF(DAY,NextRun,@Date),NextRun)
	END
	WHERE NextRun <= @Date AND Active = 1 AND EventType = 1
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

-- Check to see if there's anything to update!
IF EXISTS (SELECT * FROM dbo.ForumScheduledEvents WHERE NextRun <= @Date AND (EventType = 1 OR (EventType = 0 AND LastRun IS NULL)) AND Active = 1)
BEGIN
	-- Get all the forums we need to update
	DECLARE @MaxRun table (ForumID INT, NextRun DATETIME) 
	INSERT INTO @MaxRun
		SELECT fse2.ForumID, 'NextRun' = MAX(fse2.NextRun)
			FROM dbo.ForumScheduledEvents fse2
			WHERE fse2.NextRun <= @Date AND (fse2.EventType = 1 OR (fse2.EventType = 0 AND fse2.LastRun IS NULL)) AND fse2.Active = 1
			GROUP BY fse2.ForumID

	-- Catch any errors!
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Update the forums
	UPDATE dbo.Forums SET CanWrite = fse.Action, ThreadCanWrite = fse.Action
		FROM dbo.ForumScheduledEvents fse
		JOIN @MaxRun as mr ON mr.ForumID = fse.ForumID AND fse.NextRun = mr.NextRun
		WHERE fse.ForumID = dbo.Forums.ForumID

	-- Catch any errors!
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Update the Threads
	UPDATE dbo.Threads SET CanWrite = fse.Action
		FROM dbo.ForumScheduledEvents fse
		INNER JOIN @MaxRun AS mr ON mr.ForumID = fse.ForumID AND fse.NextRun = mr.NextRun
		WHERE fse.ForumID = dbo.Threads.ForumID

	-- Catch any errors!
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
END

-- Update the NextRun and Last run values for all events
UPDATE dbo.ForumScheduledEvents SET LastRun = @Date,
	NextRun = CASE
		-- One-off events don't change
		WHEN EventType = 0 THEN NextRun
		-- weekly events go ahead by 7 days
 		WHEN DayType < 7 THEN DATEADD(DAY,7,NextRun)
		-- daily events shift to tomorrow
 		ELSE DATEADD(DAY,1,NextRun)
	END
	WHERE NextRun <= @Date AND Active = 1

-- Catch any errors!
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END
COMMIT TRANSACTION
