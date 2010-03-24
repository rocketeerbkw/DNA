CREATE PROCEDURE removeaccess @userlist VARCHAR(512), @groupname VARCHAR(64), @siteid int = null, @modclassid int = null, @clearall bit = 0
as
declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @groupname

declare @query varchar(8000)

IF @clearall = 1 
BEGIN
	delete from ModerationClassMembers WHERE UserID IN (select element FROM udf_splitvarchar(@userlist)) AND groupid = @modgroup
	delete from GroupMembers WHERE UserID IN (select element FROM udf_splitvarchar(@userlist) ) AND GroupID = @modgroup
END
ELSE IF @siteid IS NOT NULL
BEGIN
	delete from GroupMembers WHERE UserID IN (select element FROM udf_splitvarchar(@userlist) ) 
						AND SiteID = @siteid
						AND GroupID = @modgroup
						AND UserID NOT IN (select m.UserID FROM Sites s inner join ModerationClassMembers m ON s.ModClassID = m.ModClassID
												WHERE s.SiteID = @siteid)
END
ELSE IF @modclassid IS NOT NULL
BEGIN
	delete from ModerationClassMembers WHERE UserID IN (select element FROM udf_splitvarchar(@userlist) ) AND ModClassID = @modclassid AND groupid = @modgroup
	delete from GroupMembers WHERE UserID IN (select element FROM udf_splitvarchar(@userlist)) AND SiteID IN (SELECT SiteID FROM Sites WHERE ModClassID = @modclassid) AND GroupID = @modgroup
END
