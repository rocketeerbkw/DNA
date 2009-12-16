CREATE PROCEDURE fetchnicknamemoderationbatch @userid int
AS
-- count if we have any locked already
DECLARE @Error int
DECLARE @AlreadyGot int
SELECT @AlreadyGot = COUNT(*)
FROM NicknameMod
WHERE Status = 1 AND LockedBy = @userid
declare @issuperuser int
select @issuperuser = CASE WHEN Status = 2 then 1 ELSE 0 END FROM Users where UserID = @userid

-- Don't fetch a new batch if the user currently has a batch pending
IF (@AlreadyGot = 0)
BEGIN
	BEGIN TRANSACTION
	
	-- Make sure the same date is used in all places
	DECLARE @date datetime
	SET @date = getdate()
	
	-- Use UPDLOCK on SELECT statement to ensure we get same result set in INSERT statement
	-- and the following UPDATE statement
	INSERT NicknameModHistory (ModID,StatusID,LockedByChanged,LockedBy,TriggerID,TriggeredBy,DateCreated)
		SELECT TOP 20 ModID,1,1,@userid,0,@userid,@date
			FROM NicknameMod (UPDLOCK)
			WHERE Status = 0 AND LockedBy IS NULL AND (@issuperuser = 1 OR SiteID IN
			(	SELECT gm.SiteID FROM GroupMembers gm WITH (NOLOCK)
				INNER JOIN Groups g WITH (NOLOCK) ON g.GroupID = gm.GroupID
				WHERE g.Name = 'editor' AND gm.UserID = @userid ))
			ORDER BY DateQueued ASC, ModID ASC
	SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
	
	UPDATE NicknameMod
	SET Status = 1, LockedBy = @userid, DateLocked = @date
	FROM (	SELECT TOP 20 ModID
			FROM NicknameMod
			WHERE Status = 0 AND LockedBy IS NULL AND (@issuperuser = 1 OR SiteID IN
			(	SELECT gm.SiteID FROM GroupMembers gm WITH (NOLOCK)
				INNER JOIN Groups g WITH (NOLOCK) ON g.GroupID = gm.GroupID
				WHERE g.Name = 'editor' AND gm.UserID = @userid ))
			ORDER BY DateQueued ASC, ModID ASC) AS NM1
	WHERE NM1.ModID = NicknameMod.ModID
	SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
	
	COMMIT TRANSACTION
END

SELECT	NM.ModID, 
		NM.UserID,
		NM.DateQueued,
		NM.DateLocked,
		NM.LockedBy,
		NM.Status,
		NM.DateCompleted,
		NM.SiteId,
		NM.ComplainantId,
		NM.ComplaintText,
		ISNULL(NM.NickName,U.UserName) 'UserName', --Support for premoderated nickname.
		U.FirstNames, 
		U.LastName, 
		P.SiteSuffix
	FROM NicknameMod NM
	INNER JOIN Users U ON U.UserID = NM.UserID
	LEFT JOIN Preferences P ON u.UserID = P.UserID AND NM.SiteID = P.SiteID
	WHERE NM.Status = 1 AND NM.LockedBy = @userid
ORDER BY NM.DateQueued ASC, NM.ModID ASC

RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @Error
RETURN @Error


