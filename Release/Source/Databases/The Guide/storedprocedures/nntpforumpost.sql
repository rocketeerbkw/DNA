Create Procedure nntpforumpost @userid int, @id int, @inreplyto int = NULL, @subject varchar(255), @content text, @idtype int = 0
As
declare @threadid int, @forumid int
if @idtype = 0 -- regular forum id
	SELECT @forumid = @id
ELSE IF @idtype = 1 -- User ID message board
	SELECT @forumid = g.ForumID
		FROM Users u
		INNER JOIN GuideEntries g ON u.Masthead = g.h2g2ID
		WHERE u.UserID = @id
ELSE IF @idtype = 2 -- User journal
	SELECT @forumid = Journal
		FROM Users
		WHERE UserID = @id
ELSE IF @idtype = 3 -- article forum
	SELECT @forumid = ForumID
		FROM GuideEntries
		WHERE h2g2id = @id
SELECT @threadid = ThreadID FROM ThreadEntries WHERE EntryID = @inreplyto
DECLARE @ReturnCode INT
EXEC @ReturnCode = posttoforum @userid, @forumid, @inreplyto, @threadid, @subject, @content, NULL, '', NULL

RETURN @ReturnCode
