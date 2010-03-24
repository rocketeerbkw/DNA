CREATE PROCEDURE addinterest @userid int, @siteid int, @interest varchar(50)
as
BEGIN TRANSACTION
INSERT INTO Groups (Name, System, UserInfo, Owner)
VALUES (@interest, 2, 0, @userid)

declare @groupid int
select @groupid = GroupID FROM Groups where Name = @interest AND System = 2

if @groupid IS NULL
BEGIN
ROLLBACK TRANSACTION
select 'GroupID' = @groupid
return 0
END

INSERT INTO GroupMembers (GroupID, UserID, SiteID)
VALUES(@groupid, @userid, @siteid)
COMMIT TRANSACTION
select 'GroupID' = @groupid
return 0