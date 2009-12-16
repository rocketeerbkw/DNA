create procedure deletelink @linkid int, @userid int, @siteid int
as

-- does the user have permission to delete this link regardless of being a member
-- of the team associated with the link?
-- I.e. is the user an Editor or a super user?

DECLARE @userhaspermissions INT
SELECT @userhaspermissions = (
		SELECT 'found'=1 FROM Users u WHERE u.userid = @userid and u.status =2
		UNION
		SELECT 'found'=1 FROM GroupMembers gm 
			INNER JOIN Groups g ON g.GroupID = gm.GroupID and g.name = 'Editor'
			WHERE gm.userid = @userid and gm.siteid = @siteid
		union
		select 'found'=1 from links l, teammembers tm where l.teamid = tm.teamid 
			and tm.userid=@userid and l.linkid=@linkid		
	)

IF @userhaspermissions = 1
BEGIN
	delete from externalurls from externalurls eu, links l where 
		eu.urlid = l.destinationid and l.destinationtype='external' 
		and l.linkid=@linkid;

	DELETE FROM Links WHERE LinkID = @linkid;
	select 'rowcount'=@@ROWCOUNT
END
ELSE
BEGIN
	select 'rowcount'=0
END