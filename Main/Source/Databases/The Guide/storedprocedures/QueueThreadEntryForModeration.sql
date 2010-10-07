CREATE PROCEDURE queuethreadentryformoderation @forumid int, @threadid int, @entryid int, @siteid int, @modnotes VARCHAR(255)
AS
	INSERT INTO dbo.ThreadMod ( ForumID,  ThreadID,  PostID,  Status, NewPost, SiteID,  Notes)
		               VALUES (@forumid, @threadid, @entryid, 0,      1,      @siteid, @modnotes)
