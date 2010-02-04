CREATE PROCEDURE addthreadtostickylist @userid int, @forumid int, @threadid int
As

begin tran

	declare @sortby int
	
	select @sortby=  max(sortby) + 1 from StickyThreads where threadid=@threadid and forumid=@forumid
	if @sortby is null 
	BEGIN
		set @sortby = 0
	END
	ELSE
	BEGIN
		set @sortby = @sortby + 1
	END
	
		
	

	insert into StickyThreads
	(forumid, threadid, userid, sortby)
	values
	(@forumid, @threadid,@userid, @sortby)

	INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
	values
	(@forumid, getdate())

	insert into AuditStickyThreads
	(forumid, threadid, userid, type)
	values
	(@forumid, @threadid,@userid, 2)

commit tran