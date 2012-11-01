CREATE PROCEDURE searchfortwitteruserviascreenname @viewinguserid int, @twitterscreenname varchar(255), @checkallsites tinyint
AS
-- Get the Editor group id from the groups table  
--  DECLARE @EditorGroupID int  
--  SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';  

SELECT 
		u.UserID
		, u.UserName
		, u.LoginName
		, NULL AS Email
		, p.PrefStatus
		, us.UserStatusDescription
		, ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration
		, p.PrefStatusChangedDate
		, p.SiteID
		, s.ShortName  
		, s.urlname
		, sm.TwitterUserID
		, sm.IdentityUserID
		, u.Status as 'Status'
		, p.DateJoined
	FROM Users u WITH (NOLOCK)
	INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID 
	INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID  
	INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus  
	INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID AND sm.TwitterUserID IS NOT NULL
	WHERE
		u.LoginName = @twitterscreenname
	ORDER BY u.UserID DESC, s.SiteID 