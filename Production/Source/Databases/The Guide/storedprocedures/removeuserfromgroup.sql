CREATE PROCEDURE removeuserfromgroup @userid int, @siteid int, @groupname varchar(50)
AS
DELETE FROM dbo.GroupMembers WHERE UserID = @userid AND SiteID = @siteid AND GroupID IN
	( SELECT GroupID FROM dbo.Groups WHERE Name = @groupname )