CREATE PROCEDURE checkpremodpostingexists @modid int, @create int
AS
IF (@Create = 0)
BEGIN
	-- Just check to see if the post exists in the thread mod table.
	SELECT ModID FROM dbo.ThreadMod WITH(NOLOCK) WHERE ModID = @ModID
END
ELSE
BEGIN
	-- check to see if the post exists in the thread mod table as a PreModPosting item
	IF EXISTS ( SELECT * FROM dbo.ThreadMod WITH(NOLOCK) WHERE ModID = @ModID AND IsPreModPosting = 1 )
	BEGIN
		BEGIN TRANSACTION
		
		-- Turn the PreModPosting post into a normal Pre Mod post
		DECLARE @ThreadID int, @PostID int, @ErrorCode int
		EXEC @ErrorCode = createpremodpostingentry @ModID, 1,  @ThreadID OUTPUT, @PostID OUTPUT
		SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode)
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @ErrorCode
		END
		
		COMMIT TRANSACTION
		SELECT 'ModID' = @ModID, 'ThreadID' = @ThreadID, 'PostID' = @PostID
	END
END