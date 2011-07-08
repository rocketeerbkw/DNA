CREATE PROCEDURE searchforuserviauserid @viewinguserid int, @usertofindid int, @checkallsites tinyint
AS

EXEC openemailaddresskey

-- Get the users email that matches the userid gievn
DECLARE @Email varchar(255)
SELECT @EMail = dbo.udf_decryptemailaddress(EncryptedEmail,UserId) FROM Users WITH(NOLOCK) WHERE UserID = @UserToFindID

-- Check to see if we found a valid email. Empty or NULL will cause major problems for the database!
IF (@Email != '' AND @Email IS NOT NULL AND @Email != '0')
BEGIN
	-- Call the internal search for user via email procedure
	DECLARE @ErrorCode INT
	EXEC @ErrorCode = SearchForUserViaEmailInternal @viewinguserid, @Email, @checkallsites
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
	-- Can't use the email to find alternative id's, just return the details for the user via their id
	IF (@CheckAllSites = 0)
	BEGIN
		-- Get the Editor group id from the groups table
		DECLARE @EditorGroupID int
		SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';

		-- Get all the user entries for the given userid for sites that the viewing user is an Editor
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) AS Email,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.SiteID,
				s.ShortName,
				s.urlname,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status',
				p.DateJoined
			FROM Users u WITH(NOLOCK)
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			WHERE u.UserID = @UserToFindID
			ORDER BY u.UserID DESC, s.SiteID
	END
	ELSE
	BEGIN
		-- Get all the user entries for the given userid for all sites
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) AS Email,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.SiteID,
				s.ShortName,
				s.urlname,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status',
				p.DateJoined	
			FROM Users u WITH(NOLOCK)
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			WHERE u.UserID = @UserToFindID 
			ORDER BY u.UserID DESC, s.SiteID
	END
END
