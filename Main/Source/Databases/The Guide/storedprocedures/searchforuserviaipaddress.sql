CREATE PROCEDURE searchforuserviaipaddress @viewinguserid int, @ipaddress varchar(25), @checkallsites tinyint
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

EXEC openemailaddresskey

-- Check to see we've been given a valid name. Don't do anything if it's empty or NULL
IF (@ipaddress != '' AND @ipaddress IS NOT NULL) 
BEGIN
	IF (@CheckAllSites = 0)
	BEGIN
		-- Get the Editor group id from the groups table
		DECLARE @EditorGroupID int
		SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';

		WITH CTE_ThreadEntriesForIPAddress AS 
		(
			SELECT UserID FROM ThreadEntries te WITH(NOLOCK)
			INNER JOIN ThreadEntriesIPAddress teip WITH(NOLOCK) ON teip.EntryID = te.EntryID
			WHERE teip.IPAddress = @ipaddress
		)
		, CTE_DistinctUsers AS
		(
			SELECT DISTINCT UserID 
			FROM CTE_ThreadEntriesForIPAddress cteteip
		)		
		-- Get all the user entries for the given ip address for sites that the viewing user is an Editor
		SELECT  u.UserID,
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
				@ipaddress,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status',
				p.DateJoined	
			FROM CTE_DistinctUsers ctedu
			INNER JOIN Users u WITH(NOLOCK) ON u.UserID = ctedu.UserID
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = @ViewingUserID AND gm.GroupID = @EditorGroupID AND gm.SiteID = s.SiteID
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			ORDER BY u.UserID DESC, p.SiteID
	END
	ELSE
	BEGIN
		WITH CTE_ThreadEntriesForIPAddress AS 
		(
			SELECT UserID FROM ThreadEntries te WITH(NOLOCK)
			INNER JOIN ThreadEntriesIPAddress teip WITH(NOLOCK) ON teip.EntryID = te.EntryID
			WHERE teip.IPAddress = @ipaddress
		)
		, CTE_DistinctUsers AS
		(
			SELECT DISTINCT UserID 
			FROM CTE_ThreadEntriesForIPAddress cteteip
		)		
		-- Get all the user entries for the given ipaddresses for all sites
		SELECT  u.UserID,
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
				@ipaddress,
				sm.SSOUserID,
				sm.IdentityUserID,
				u.Status as 'Status',
				p.DateJoined	
			FROM CTE_DistinctUsers ctedu
			INNER JOIN Users u WITH(NOLOCK) ON u.UserID = ctedu.UserID
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID
			ORDER BY u.UserID DESC, p.SiteID
	END
END
