CREATE PROCEDURE deleteforumevent @e0 int, @e1 int = NULL, @e2 int = NULL, @e3 int = NULL, @e4 int = NULL,
					@e5 int = NULL, @e6 int = NULL, @e7 int = NULL, @e8 int = NULL, @e9 int = NULL,
					@e10 int = NULL, @e11 int = NULL, @e12 int = NULL, @e13 int = NULL, @e14 int = NULL,
					@e15 int = NULL, @e16 int = NULL, @e17 int = NULL, @e18 int = NULL, @e19 int = NULL
AS
DECLARE @error int
BEGIN TRANSACTION
DELETE FROM ForumScheduledEvents WHERE EventID IN
(
	@e0 , @e1, @e2 , @e3 , @e4 , @e5 , @e6 , @e7 , @e8 , @e9 ,
	@e10 , @e11 , @e12 , @e13 , @e14 , @e15 , @e16 , @e17 , @e18 , @e19 
)
SELECT @error = @@eRROR
IF (@error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @error
	RETURN @error
END
COMMIT TRANSACTION


