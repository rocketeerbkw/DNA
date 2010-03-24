CREATE PROCEDURE createforumevent @daytype TinyInt, @eventtime DateTime, @eventtype TinyInt, @action TinyInt, @deleteexisting tinyint,
	@f0 int, @f1 int = NULL, @f2 int = NULL, @f3 int = NULL, @f4 int = NULL, @f5 int = NULL, @f6 int = NULL, @f7 int = NULL, @f8 int = NULL, @f9 int = NULL,
	@f10 int = NULL, @f11 int = NULL, @f12 int = NULL, @f13 int = NULL, @f14 int = NULL, @f15 int = NULL, @f16 int = NULL, @f17 int = NULL, @f18 int = NULL, @f19 int = NULL
AS
DECLARE @Error int, @Today tinyint, @EventDate DateTime, @DaysToAdd int

-- Get the current day type
SELECT @Today = CASE
	WHEN DATENAME(w,GetDate()) = 'Monday' THEN 0
	WHEN DATENAME(w,GetDate()) = 'Tuesday' THEN 1
	WHEN DATENAME(w,GetDate()) = 'Wednesday' THEN 2
	WHEN DATENAME(w,GetDate()) = 'Thursday' THEN 3
	WHEN DATENAME(w,GetDate()) = 'Friday' THEN 4
	WHEN DATENAME(w,GetDate()) = 'Saturday' THEN 5
	ELSE 6
END

-- Now make sure the date in the eventtime is set correctly. If the date is in the past set normalize it 
-- Dates in the future are already correct.
SELECT @DaysToAdd = 0
IF (@eventtime < GetDate() AND @eventtype = 1)
BEGIN
	IF (@daytype < 7)
	BEGIN
		IF (@daytype >= @ToDay)
			SELECT @DaysToAdd = @daytype - @ToDay
		ELSE
			SELECT @DaysToAdd = (@daytype + 6) - @Today + 1
	END
	SELECT @DaysToAdd = DATEDIFF(DAY,@eventtime,GetDate()) + @DaysToAdd
	SELECT @EventDate = DATEADD(DAY,@DaysToAdd,@eventtime)
END
ELSE
	SELECT @EventDate = @eventtime
	
BEGIN TRANSACTION

IF (@daytype < 7)
BEGIN
	-- Delete any existing events for the forums which match the same eventtype OR recursive (DT = 7) AND Action = @action
	DELETE FROM ForumScheduledEvents WHERE
		(( DayType = @daytype AND [Action] = @action AND EventType = @eventtype ) OR ( DayType = 7 AND [Action] = @action))
		AND
		ForumID IN 
		(
			@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
			@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
		)
	SELECT @Error = @@ERROR
END
ELSE IF (@daytype = 7 AND @eventtype = 1)
BEGIN
	-- Delete any existing events for the forums which match the same Action
	DELETE FROM ForumScheduledEvents WHERE
		[Action] = @action AND
		ForumID IN 
		(
			@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
			@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
		)
	SELECT @Error = @@ERROR
END
ELSE IF (@eventtype = 0)
BEGIN
	-- Delete All existsing events as we're creating a one off!!!
	DELETE FROM ForumScheduledEvents WHERE ForumID IN 
		(
			@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
			@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
		)
	SELECT @Error = @@ERROR
END
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

/*
-- Delete any existing matching events
DELETE FROM ForumScheduledEvents WHERE
	DayType = @daytype AND
	[Action] = @action AND
	EventType = @eventtype AND
	ForumID IN 
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
*/

-- Now insert the new events
INSERT INTO ForumScheduledEvents SELECT ForumID, @daytype, @eventtype, @action, 1, @EventDate, NULL FROM Forums WHERE ForumID IN 
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

COMMIT TRANSACTION

SELECT f.*, ForumOpen = t.CanWrite
FROM ForumScheduledEvents f
INNER JOIN Forums t ON t.ForumID = f.ForumID
WHERE f.ForumID IN
(
		@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
		@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
)
ORDER BY f.ForumID
