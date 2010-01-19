CREATE PROCEDURE giveaccess @userlist VARCHAR(255), @groupname VARCHAR(64), @siteid INT = null, @modclassid INT = null
as

declare @modgroup int
select @modgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @groupname

IF @siteid IS NOT NULL
BEGIN
	delete from GroupMembers WHERE UserID IN 
	( SELECT element FROM udf_splitvarchar(@userlist) ) AND SiteID = @siteid AND GroupID = @modgroup
	
	insert into GroupMembers (GroupID, UserID, SiteID)
	SELECT @modgroup, UserID, @siteid 
	FROM Users u
	INNER JOIN udf_splitvarchar(@userlist) v ON v.element = u.userid
END
ELSE IF @modclassid IS NOT NULL
BEGIN
	INSERT INTO Moderators (UserID) 
	SELECT UserID FROM Users u
	INNER JOIN udf_splitvarchar(@userlist) v ON v.element = u.userid
	WHERE UserID NOT IN (SELECT UserID FROM Moderators)
	
	delete from ModerationClassMembers 
	WHERE UserID IN (select element FROM udf_splitvarchar(@userlist) ) AND ModClassID = @modclassid AND groupid = @modgroup
	
	insert into ModerationClassMembers (UserID, ModClassID, GroupId)
	SELECT UserID, @modclassid, @modgroup
	FROM Users u
	INNER JOIN udf_splitvarchar(@userlist) v ON v.element = u.userid
	
	delete from GroupMembers 
	WHERE UserID IN (select element FROM udf_splitvarchar(@userlist)) AND SiteID IN (SELECT SiteID FROM Sites WHERE ModClassID = @modclassid) AND GroupID = @modgroup
	
	insert into GroupMembers (GroupID, UserID, SiteID)
	SELECT @modgroup, UserID, s.SiteID 
	FROM Users u
	INNER JOIN udf_splitvarchar(@userlist) v ON v.element = u.userid
	INNER JOIN Sites s ON s.modclassid = @modclassid
END