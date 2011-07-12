CREATE PROCEDURE searchforuserviaemailinternal @viewinguserid int, @email varchar(255), @checkallsites tinyint
AS

EXEC openemailaddresskey

-- Please note that you should check to make sure that the email is not null or empty before calling this procedure
-- as doing so will most likley cause a database slow down
-- See if we want all sites or just the ones the viewing user is an editor on
IF (@CheckAllSites = 0)
BEGIN
	-- Get the Editor group id from the groups table
	DECLARE @EditorGroupID int
	SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';

	-- Get all the user entries for the given email fo sites that the viewing user is an Editor
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
		WHERE u.HashedEmail = dbo.udf_hashemailaddress(@Email)
		ORDER BY u.UserID DESC, s.SiteID
END
ELSE
BEGIN
	-- Get all the user entries for the given email for all sites
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
		WHERE u.HashedEmail = dbo.udf_hashemailaddress(@Email)
		ORDER BY u.UserID DESC, s.SiteID
END