CREATE PROCEDURE watchuserjournal @userid int, @watcheduserid int, @siteid int
As
declare @journal int, @ErrorCode int, @username varchar(255)
BEGIN TRANSACTION

SELECT @journal = ForumID FROM Journals where UserID = @watcheduserid and siteid = @siteid
select @username = UserName FROM Users WHERE UserID = @watcheduserid


/*	We're starting a new journal 
	For journal forums, JournalOwner = the ID of the user
	for non-journal forums, it's NULL
*/
IF @journal IS NULL
BEGIN
	INSERT INTO Forums (Title, JournalOwner, SiteID) 
		VALUES('User-journal', @watcheduserid, @siteid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	SELECT @journal = @@IDENTITY
	
	UPDATE Users SET Journal = @journal WHERE UserID = @watcheduserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

IF NOT EXISTS (SELECT * FROM FaveForums WHERE UserID = @userid AND ForumID = @journal)
BEGIN
	INSERT INTO FaveForums (ForumID, UserID)
	VALUES(@journal, @userid)
END
COMMIT TRANSACTION

SELECT u.userid, u.userName, u.firstnames, u.Lastname, u.area, u.status, u.taxonomynode, 'journal' = J.ForumID, u.active, p.title, p.sitesuffix 
FROM users AS u WITH(NOLOCK) 
INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @siteid
LEFT JOIN preferences AS p WITH(NOLOCK) ON (p.userid = u.userid) AND (p.siteid = @siteid)
WHERE u.userID = @watcheduserid

RETURN 0
