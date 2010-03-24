CREATE PROCEDURE setforumtitle @forumid int, @title nvarchar(255)
AS
BEGIN
	UPDATE Forums Set Title = @title WHERE ForumID = @forumid
END