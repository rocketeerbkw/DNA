CREATE PROCEDURE isusermemberofgroup @userid int, @siteid int, @groupname varchar(50),
										@exists int OUTPUT
As

SELECT @exists=0

IF EXISTS(SELECT * FROM dbo.Groups g
			INNER JOIN dbo.GroupMembers gm ON g.GroupID = gm.GroupID
			WHERE gm.UserID = @userid AND g.Name = @groupname AND g.UserInfo = 1 AND gm.SiteID = @siteid)
BEGIN
	SELECT @exists=1
END
