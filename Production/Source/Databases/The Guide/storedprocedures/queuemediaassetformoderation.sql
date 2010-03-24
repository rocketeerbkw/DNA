/*
	Currently media asset moderation is simple (only has pass and fail options)
	so this SP does not have to do anything except insert the media asset if it
	is not already in the queue.
*/

CREATE PROCEDURE queuemediaassetformoderation 
	@mediaassetid int , 
	@siteid int, 	
	@complainantid int = null,
	@correspondenceemail varchar(255) = null,
	@complainttext text = null
 
AS
DECLARE @ModID int, @ErrorCode int

-- first find out if asset is already queued and not dealt with or refered.
SELECT TOP 1 @ModID = ModID
FROM MediaAssetMod
WHERE MediaAssetID = @mediaassetid  AND ((Status = 0 AND lockedBy IS NULL) OR (Status = 2 AND DateCompleted IS NULL))
ORDER BY DateQueued

IF ( @ModID IS NULL )
BEGIN
	INSERT INTO MediaAssetMod ( MediaAssetID, SiteId, Status, DateQueued, ComplainantID, Email, ComplaintText)
		VALUES (@mediaassetid, @siteid, 0,  getdate(), @complainantid, @correspondenceemail, @complainttext )
	SELECT @ErrorCode = @@ERROR
	
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @ModID = @@identity
	
	--EXEC @Error = addmediaassetmodhistory @ModID,0,0,NULL,3,NULL,@date
	--SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF @Error <> 0 GOTO HandleError
	
END
--ELSE
--BEGIN
	--Record the event in nickname mod history.
	--EXEC @Error = addmediaassetmodhistory @ModID,0,0,NULL,3,NULL,getdate()
--END

-- return the ModID
SELECT 'ModID' = @ModID

RETURN (0)