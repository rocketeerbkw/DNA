CREATE PROCEDURE addnewmoderatortoclasses @classlist VARCHAR(512), @userid int, @groupname VARCHAR(64)
as

declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @groupname

delete from ModerationClassMembers 
	WHERE UserID = @userid AND groupid = @modgroup
	
insert into ModerationClassMembers (UserID, ModClassID, GroupID)
	SELECT UserID, ModClassID, @modgroup FROM Users u, ModerationClass m WHERE UserID = @userid AND m.ModClassID IN ( SELECT element FROM udf_splitvarchar(@classlist))
delete from GroupMembers WHERE UserID = @userid AND GroupID = @modgroup AND SiteID IN (SELECT SiteID FROM Sites WHERE ModClassID IN ( SELECT element FROM udf_splitvarchar(@classlist)))
insert into GroupMembers (GroupID, UserID, SiteID)
SELECT @modgroup, UserID, s.SiteID FROM Users u, Sites s WHERE u.UserID = @userid AND s.ModClassID IN ( SELECT element FROM udf_splitvarchar(@classlist)) 
