CREATE PROCEDURE posttoforumwithemail @email varchar(255), @forumid int, @inreplyto int, @threadid int, @subject nvarchar(255), @content nvarchar(max), @keywords varchar(255)
AS
declare @userid int


SELECT @userid = UserID FROM Users WHERE @email = email

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF (@userid IS NULL)
BEGIN
	EXEC @ErrorCode = storenewemaildirect @email
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	SELECT @userid = @@IDENTITY
END
if (NOT (@userid IS NULL))
BEGIN
	EXEC @ErrorCode = posttoforum @userid, @forumid, @inreplyto, @threadid, @subject, @content, NULL, @keywords
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

COMMIT TRANSACTION


