CREATE PROCEDURE addusertogroup @userid int, @siteid int, @groupname varchar(50)
AS
DECLARE @GroupID int
SELECT @GroupID = groupid from dbo.groups where name = @groupname
IF (@GroupID > 0)
BEGIN
	INSERT INTO dbo.GroupMembers SELECT userid = @userid, groupid = @GroupID, siteid = @SiteID
END