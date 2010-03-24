CREATE PROCEDURE deleteforumeventsmatching @daytype TinyInt, @eventtype TinyInt, @action TinyInt, @f0 int, @f1 int = NULL, @f2 int = NULL,
								@f3 int = NULL, @f4 int = NULL, @f5 int = NULL, @f6 int = NULL, @f7 int = NULL, @f8 int = NULL, @f9 int = NULL,
								@f10 int = NULL, @f11 int = NULL, @f12 int = NULL, @f13 int = NULL, @f14 int = NULL, @f15 int = NULL,
								@f16 int = NULL, @f17 int = NULL, @f18 int = NULL, @f19 int = NULL
AS
DECLARE @Error int
BEGIN TRANSACTION
DELETE FROM ForumScheduledEvents
WHERE DayType = @daytype AND EventType = @eventtype AND Action = @action AND ForumID IN
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