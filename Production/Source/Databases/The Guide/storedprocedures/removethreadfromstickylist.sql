CREATE PROCEDURE removethreadfromstickylist @forumid int, @threadid int, @userid int
As

begin tran


	delete from StickyThreads
	where forumid = @forumid and threadid = @threadid

	INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
	values
	(@forumid, getdate())

	insert into AuditStickyThreads
		(forumid, threadid, userid, type)
		values
		(@forumid, @threadid,@userid, 1)


commit tran