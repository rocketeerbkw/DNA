
CREATE PROCEDURE addarticletoreviewforummembers @h2g2id int, @reviewforumid int, @submitterid int, @subject varchar(255), @content text, @hash uniqueidentifier
As

declare @forumid int, @threadid int, @postid int, @recachegroups tinyint
select @forumid = g.ForumID FROM ReviewForums r
	INNER JOIN GuideEntries g ON g.EntryID = r.h2g2ID/10
	WHERE r.ReviewForumID = @reviewforumid

IF (@forumid IS NOT NULL)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	EXEC @ErrorCode = posttoforuminternal @submitterid, @forumid, NULL, 0, @subject, @content, 2, @hash, NULL, NULL, @threadid OUTPUT, @postid OUTPUT,
						/*@type*/DEFAULT, /*@eventdate*/ DEFAULT, /*@forcemoderate*/DEFAULT,  /*@forcepremoderation*/DEFAULT, /*@ignoremoderation*/ DEFAULT, /*@allowevententries*/ DEFAULT,
						/*@nodeid*/DEFAULT,/*@ipaddress*/DEFAULT, /*@queueid*/DEFAULT, /*@clubid*/ DEFAULT, /*@ispremodposting*/ null, /*@ispremoderated*/ null, /*@bbcuid*/ DEFAULT, 
						/*@isnotable*/ DEFAULT, /*@iscomment*/ DEFAULT
	
	IF @threadid = 0 OR @ErrorCode <> 0
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'ThreadID' = 0, 'PostID' = 0, 'ForumID' = 0
		RETURN @ErrorCode
	END

	INSERT INTO ReviewForumMembers (H2G2ID,ReviewForumID,SubmitterID,ThreadID,PostID,ForumID)
		VALUES(@h2g2id,@reviewforumid,@submitterid,@threadid,@postid,@forumid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'ThreadID' = 0, 'PostID' = 0, 'ForumID' = 0
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'Success' = 1, 'ThreadID' = @threadid, 'PostID' = @postid, 'ForumID' = @forumid
END

return(0)