CREATE PROCEDURE setforumhosturl @forumid int, @url nvarchar(255)
AS
BEGIN
	UPDATE CommentForums Set url = @url WHERE ForumID = @forumid
END