CREATE PROCEDURE moderateexlinks @modid INT, @userid int, @decision int, @notes VARCHAR(255), @referto INT
As

IF @decision = 2
BEGIN
	UPDATE ExLinkMod 
	SET datereferred = CURRENT_TIMESTAMP, referredby = @userid, lockedby = CASE WHEN @referto = 0 THEN NULL ELSE @referto END, status = @decision, notes = @notes
	WHERE modid = @modid
END
ELSE
BEGIN
	UPDATE ExLinkMod 
	SET datecompleted = CURRENT_TIMESTAMP, status = @decision, notes = @notes
	WHERE modid = @modid
	
	DECLARE @uri VARCHAR(255)
	SELECT @uri = uri FROM ExLinkMod WHERE modid = @modid
	
	EXEC addtoeventqueueinternal 'ET_EXMODERATIONDECISION', @modid, 'IT_MODID', 0, 'IT_ALL', @userid
END

