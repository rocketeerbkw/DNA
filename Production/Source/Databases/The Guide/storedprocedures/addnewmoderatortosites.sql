CREATE PROCEDURE addnewmoderatortosites @sitelist VARCHAR(512), @userid int, @groupname VARCHAR(64)
as

declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @groupname

delete from GroupMembers
	WHERE UserID = @userid AND GroupID = @modgroup
insert into GroupMembers (GroupID, UserID, SiteID)
SELECT @modgroup, UserID, s.SiteID FROM Users u, Sites s WHERE u.UserID = @userid AND s.SiteID IN ( SELECT element FROM udf_splitvarchar(@sitelist)) 
