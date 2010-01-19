CREATE PROCEDURE getsitesuseriseditorof @userid int 
AS
	IF (SELECT Status FROM Users WHERE UserID = @userid) = 2
	BEGIN
		-- User is super-user so return all SiteIDs
		SELECT SiteID
		  FROM dbo.Sites WITH(NOLOCK)
		 ORDER BY ShortName
	END 
	ELSE
	BEGIN 
		SELECT gm.SiteID
		  FROM dbo.Users u WITH(NOLOCK)
			   INNER JOIN dbo.GroupMembers gm WITH(NOLOCK) ON gm.UserID = u.UserID
			   INNER JOIN dbo.Sites s WITH(NOLOCK) ON s.SiteID = gm.SiteID
		 WHERE u.UserID = @userid
		   AND gm.GroupID = 8 -- editor (see dbo.Groups)
		 ORDER BY s.ShortName ASC
	END 


RETURN @@ERROR 
