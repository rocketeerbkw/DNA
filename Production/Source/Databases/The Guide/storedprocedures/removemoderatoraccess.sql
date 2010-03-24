CREATE PROCEDURE removemoderatoraccess @userlistid uniqueidentifier, @accessid int, @accesstype varchar(30)
as
declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Moderator'

declare @query varchar(8000)

IF @accesstype = 'site'
BEGIN
	delete from GroupMembers WHERE UserID IN (select UserID from TempUserList t WHERE UID = @userlistid) 
						AND SiteID = @accessid
						AND GroupID = @modgroup
						AND UserID NOT IN (select m.UserID FROM Sites s inner join ModerationClassMembers m ON s.ModClassID = m.ModClassID
												WHERE s.SiteID = @accessid)
END
ELSE IF @accesstype = 'class'
BEGIN
	delete from ModerationClassMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND ModClassID = @accessid 
	delete from GroupMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND SiteID IN (SELECT SiteID FROM Sites WHERE ModClassID = @accessid) AND GroupID = @modgroup
END
ELSE IF @accesstype = 'all'
BEGIN
	delete from ModerationClassMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid)
	delete from GroupMembers WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) AND GroupID = @modgroup
	delete from Moderators WHERE UserID IN (select UserID from TempUserList WHERE UID = @userlistid) 
END

select * from users u inner join TempUserList t on u.UserID = t.UserID WHERE t.UID = @userlistid

EXEC flushtempuserlist @userlistid
