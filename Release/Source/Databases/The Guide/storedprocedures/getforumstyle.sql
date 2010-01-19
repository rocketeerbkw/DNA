CREATE PROCEDURE getforumstyle @forumid int
AS
BEGIN
	SELECT ForumStyle FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
END