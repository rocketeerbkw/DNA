Create Procedure subscribetoforum @userid int, @forumid int
as
IF NOT EXISTS (SELECT * FROM FaveForums WHERE UserID=@userid And ForumID = @forumid)
INSERT INTO FAVEFORUMS (UserID, ForumID) VALUES (@userid, @forumid)