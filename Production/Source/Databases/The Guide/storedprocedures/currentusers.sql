Create Procedure currentusers @siteid int, @currentsiteonly int = NULL 
As
declare @edgroup int
select @edgroup = groupid from groups WITH(NOLOCK) where name = 'editor' and userinfo = 1

IF NOT @currentsiteonly IS NULL
BEGIN
	--Fetch recently logged users for the specified site.
	SELECT u.* , 'editor' = CASE WHEN g.groupid IS NOT NULL THEN 1 ELSE 0 END
	FROM Users u WITH(NOLOCK, INDEX=PK_Users) 
	LEFT JOIN GroupMembers g WITH(NOLOCK) ON g.userid = u.UserID AND g.GroupID = @edgroup AND g.siteid = @siteid
	WHERE u.UserID IN ( SELECT UserID FROM Sessions WITH(NOLOCK,INDEX=Sessions00) WHERE DateLastLogged > DATEADD(minute,-15,getdate()) AND SITEID = @siteid)
END
ELSE
BEGIN
	--Fetch all recently logged users.
	SELECT u.* , 'editor' = CASE WHEN g.groupid IS NOT NULL THEN 1 ELSE 0 END
	FROM Users u WITH(NOLOCK, INDEX=PK_Users) 
	LEFT JOIN GroupMembers g WITH(NOLOCK) ON g.userid = u.UserID AND g.GroupID = @edgroup AND g.siteid = @siteid
	WHERE u.UserID IN ( SELECT UserID FROM Sessions WITH(NOLOCK,INDEX=Sessions00) WHERE DateLastLogged > DATEADD(minute,-15,getdate()))
END
return (0)