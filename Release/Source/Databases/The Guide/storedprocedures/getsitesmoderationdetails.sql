CREATE PROCEDURE getsitesmoderationdetails @userid INT = NULL, @issuperuser BIT = 0, @referees BIT = 0
as

--Return all sites for superusers / no filter required.
IF @userid IS NULL OR @issuperuser <> 0
BEGIN
	SELECT s.shortname, s.siteid, s.modclassid, s.description, s.urlname
	FROM Sites s
END
ELSE
BEGIN

	--Filter the returned sites based on the users permissions
	DECLARE @refereegroup INT
	SELECT @refereegroup = groupid FROM Groups WHERE name = 'referee'

	SELECT s.shortname, s.siteid, s.modclassid, s.description
	FROM Sites s
	LEFT JOIN GroupMembers gm ON gm.UserId = @userid AND gm.SiteId = s.SiteId
	WHERE gm.GroupId = @refereegroup
END
	
RETURN @@ERROR