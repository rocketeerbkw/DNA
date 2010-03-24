CREATE PROCEDURE givemoderatoraccess @userlistid uniqueidentifier, @accessid int, @accesstype varchar(50)
as

declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Moderator'

declare @query varchar(8000)

IF @accesstype = 'site'
BEGIN
	delete from GroupMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND SiteID = @accessid AND GroupID = @modgroup
	insert into GroupMembers (GroupID, UserID, SiteID)
	SELECT @modgroup, UserID, @accessid FROM Users WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid)
END
ELSE IF @accesstype = 'class'
BEGIN
	INSERT INTO Moderators (UserID) SELECT UserID FROM Users WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND UserID NOT IN (SELECT UserID FROM Moderators)
	delete from ModerationClassMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND ModClassID = @accessid 
	insert into ModerationClassMembers (UserID, ModClassID)
	SELECT UserID, ModClassID FROM Users u, ModerationClass m WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND m.ModClassID = @accessid
	delete from GroupMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND SiteID IN (SELECT SiteID FROM Sites WHERE ModClassID = @accessid) AND GroupID = @modgroup
	insert into GroupMembers (GroupID, UserID, SiteID)
	SELECT @modgroup, UserID, s.SiteID FROM Users u, Sites s WHERE u.UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND s.ModClassID = @accessid
END
select * from users u inner join TempUserList t on u.UserID = t.UserID WHERE t.UID = @userlistid

EXEC flushtempuserlist @userlistid

