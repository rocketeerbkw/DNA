CREATE PROCEDURE addfriend @userid int, @friendid int, @siteid int
As
declare @name varchar(50)
select @name = 'Friend_' + CAST(@userid as varchar)
BEGIN TRANSACTION
INSERT INTO Groups (Name, System, UserInfo, Owner)
VALUES (@name, 1, 0, @userid)

declare @groupid int
select @groupid = GroupID FROM Groups where Name = @name AND System = 1 AND Owner = @userid

if @groupid IS NULL
BEGIN
ROLLBACK TRANSACTION
select 'GroupID' = @groupid
return 0
END

INSERT INTO GroupMembers (GroupID, UserID, SiteID)
VALUES(@groupid, @friendid, @siteid)
COMMIT TRANSACTION
select 'GroupID' = @groupid
return 0