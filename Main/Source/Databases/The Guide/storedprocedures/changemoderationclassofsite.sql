CREATE PROCEDURE changemoderationclassofsite @siteid int, @classid int
as

declare @ErrorCode INT
declare @modgroupid int
select @modgroupid = GroupID FROM Groups where Name = 'Moderator'

declare @editorgroupid int
select @editorgroupid = GroupID FROM Groups where Name = 'Editor'

declare @notablegroupid int
select @notablegroupid = GroupID FROM Groups where Name = 'Notables'

declare @currentclassid INT
select @currentclassid = modclassid from sites where siteid = @siteid
IF @classid = @currentclassid 
BEGIN
    -- Site already belongs to given mod class.
    Select 'Result' = 0
END

BEGIN TRANSACTION

IF EXISTS ( select * from Sites s INNER JOIN ModerationClass c ON s.SiteID = @siteid AND c.ModClassID = @classid )
BEGIN

DELETE FROM gm
FROM GroupMembers gm
INNER JOIN ModerationClassMembers m ON gm.userid = m.userid AND gm.groupid = m.groupid 
INNER JOIN Sites s ON s.modclassid = m.modclassid AND s.siteid = @siteid
WHERE gm.siteid = s.siteid
SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END
	
UPDATE Sites SET ModClassID = @classid WHERE SiteID = @siteid 
SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

INSERT INTO GroupMembers (UserID, GroupID, SiteID)
	SELECT u.UserID, m.GroupId, @siteid
		FROM Users u 
		INNER JOIN ModerationClassMembers m ON u.UserID = m.UserID AND m.ModClassID = @classid
		LEFT JOIN GroupMembers g ON u.UserID = g.UserID AND g.GroupID = m.GroupID AND g.SiteID = @siteid
		WHERE g.UserID IS NULL
SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

COMMIT TRANSACTION

SELECT 'Result' = 0
END
ELSE
BEGIN
SELECT 'Result' = 1, 'Reason' = 'badsiteorclass'
END