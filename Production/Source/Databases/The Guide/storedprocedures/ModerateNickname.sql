/*
	Simple version of nickname moderation that only supports passing and failing.
	- this is all that is needed currently -- TESTING REBUILDS
*/

CREATE PROCEDURE moderatenickname @modid int, @status int
AS
DECLARE @userid int
DECLARE @newnickname varchar(255)
DECLARE @nickname varchar(255)
DECLARE @Email varchar(255)
DECLARE @CurrentDate datetime
DECLARE @SiteID INT

-- make sure we use the same date for all updates
SET @CurrentDate = getdate()

EXEC openemailaddresskey

-- get the UserID we are updating, and also get their email at the same time
SELECT	@UserID = NM.UserID, 
		@Email = dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId),
		@newnickname = NM.NickName,
		@nickname = U.UserName, 
		@SiteID = NM.SiteID
	FROM NicknameMod NM
	INNER JOIN Users U ON U.UserID = NM.UserID
	INNER JOIN Sites S ON S.SiteID = NM.SiteID
	LEFT JOIN dbo.Preferences p ON p.UserID = u.UserID AND p.SiteID = NM.SIteID
	WHERE NM.ModID = @modid

BEGIN TRANSACTION
DECLARE @Error INT

EXEC @Error = addnicknamemodhistory @modid,@status,1,NULL,0,@UserID,@CurrentDate
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF @Error <> 0 GOTO HandleError

-- only need to SET the status and completed date for this simple version
UPDATE NicknameMod SET Status = @status, DateCompleted = @CurrentDate
	WHERE ModID = @modid
SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError


-- For PreMod users a nickname change will only take effect once approved by a moderator.
IF ( @status = 3 AND @nickname != @newnickname AND @newnickname IS NOT NULL AND (CHARINDEX(@nickname+'|', @newnickname) = 0))
BEGIN
	UPDATE USERS SET UserName = @newnickname WHERE UserID = @userid
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
END

-- If user is premoderated nickname change will take effect when approved by moderator (as above).
-- Revised, allow any existing username to be reset.
IF ( @status = 4 )--AND (@premoderated = 0 OR ISNULL(@PremodNicknameChanges,0)=0))
begin
	UPDATE Users SET UserName = 'U' + CAST(UserID AS varchar(20))
		WHERE UserID = @UserID
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
/*
	-- also need to run a query to flush the cache anywhere this user is referenced
	-- UPDATE GuideEntries this user is the editor of or in the researcher list
	UPDATE GuideEntries SET LastUpdated = @CurrentDate
		WHERE Editor = @UserID OR @UserID IN (SELECT UserID FROM Researchers WHERE EntryID = GuideEntries.EntryID)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

	-- UPDATE threads they have contributed to
	UPDATE Threads SET LastUpdated = @CurrentDate
		WHERE ThreadID IN (SELECT ThreadID FROM ThreadEntries WHERE UserID = @UserID)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

	-- UPDATE forums they have contributed to
	UPDATE Forums SET LastUpdated = @CurrentDate
		WHERE ForumID IN (SELECT ForumID FROM ThreadEntries WHERE UserID = @UserID)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
*/
end

COMMIT TRANSACTION

-- return the users email address
SELECT 'EmailAddress' = @Email
RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @Error
RETURN @Error
