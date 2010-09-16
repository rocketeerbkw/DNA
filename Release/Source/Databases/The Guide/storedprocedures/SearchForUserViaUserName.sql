CREATE PROCEDURE searchforuserviausername @viewinguserid int, @username varchar(255), @checkallsites tinyint
AS
-- Check to see we've been given a valid name. Don't do anything if it's empty or NULL
IF (@UserName != '' AND @UserName IS NOT NULL) 
BEGIN
	IF (@CheckAllSites = 0)
	BEGIN
		-- Get the Editor group id from the groups table
		DECLARE @EditorGroupID int
		SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';

		-- Get all the user entries for the given userid for sites that the viewing user is an Editor
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				u.Email,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.SiteID,
				s.ShortName,
				s.urlname,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status'
			FROM Users u WITH(NOLOCK)
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			WHERE u.UserName = @username
			ORDER BY u.UserID DESC, s.SiteID
	END
	ELSE
	BEGIN
		-- Get all the user entries for the given userid for all sites
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				u.Email,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.SiteID,
				s.ShortName,
				s.urlname,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status'
			FROM Users u WITH(NOLOCK)
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			WHERE u.UserName = @UserName
			ORDER BY u.UserID DESC, s.SiteID
	END
END
