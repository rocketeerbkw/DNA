-- depreciated storedprocedure
CREATE PROCEDURE updatememberprofilesacrosssites 
	@viewinguserid int, 
	@usertofindid int,	
	@prefstatus int, 
	@prefstatusduration int 
AS

EXEC openemailaddresskey

-- Get the users email that matches the userid gievn
DECLARE @Email varchar(255), @HashedEmail varbinary(900)
SELECT  @Email = dbo.udf_decryptemailaddress(EncryptedEmail,UserId),
		@HashedEmail  = HashedEmail 
		FROM Users WITH(NOLOCK) WHERE UserID = @UserToFindID

CREATE TABLE #useridsbysite (userid int, siteid int)

-- Get the Editor group id from the groups table
DECLARE @EditorGroupID int
SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';

-- Check to see if we found a valid email. Empty or NULL will cause major problems for the database!
IF (@Email != '' AND @Email IS NOT NULL AND @Email != '0')
	BEGIN
		
		--all profiles - same email address across all sites the viewing user is editor of
		INSERT into #useridsbysite (userid, siteid)
		SELECT DISTINCT u.userid, p.siteid
		FROM Users u WITH(NOLOCK) 
		INNER JOIN Preferences P WITH(NOLOCK) on P.UserID = U.UserID
		INNER JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = p.SiteID
		WHERE u.HashedEmail = @HashedEmail
	END
ELSE
	BEGIN
		--all alt ids across the sites the viewing user is editor of
		INSERT into #useridsbysite (userid, siteid)
		SELECT DISTINCT u.userid, p.siteid
		FROM Users u WITH(NOLOCK) 
		INNER JOIN Preferences P WITH(NOLOCK) on P.UserID = U.UserID
		INNER JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = p.SiteID
		WHERE u.userid = @usertofindid
	END		

		
DECLARE @userid int
DECLARE @siteid int

DECLARE C CURSOR FAST_FORWARD FOR SELECT userid, siteid FROM #useridsbysite;
OPEN C;
FETCH NEXT FROM C INTO @userid, @siteid;
WHILE @@fetch_status = 0
BEGIN
	EXEC updatetrackedmemberprofile @userid, 
									@siteid, 
									@prefstatus, 
									@prefstatusduration, 
									'',
									0,
									0
	FETCH NEXT FROM C INTO @userid, @siteid;
END
CLOSE C;
DEALLOCATE C;

DROP TABLE #useridsbysite
DROP table #groupids
