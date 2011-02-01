CREATE PROCEDURE commentratingcreate @postid int, @forumid int,  @siteid int, @userid int, @userhash uniqueidentifier, @value smallint
AS
BEGIN
	
	
	
	update dbo.ThreadEntryRating
	set value = @value
	where
		entryid = @postid
		and userid=@userid
		and userhash=@userhash
		
	if @@rowcount = 0
	begin
		insert into dbo.ThreadEntryRating
		(entryid, userid, userhash,value, forumid,siteid)
		values
		(@postid, @userid, @userhash, @value, @forumid,@siteid)
	end
	
	--update cache flag - only if more than 1 minute old
	declare @lastupdate datetime
	select @lastupdate = max(lastupdated)
	from dbo.ForumLastUpdated
	where forumid = @forumid
	

	insert into dbo.ForumLastUpdated
	(forumid, lastupdated)
	values
	(@forumid, getdate())
	
	select value
	from dbo.VCommentsRatingValue WITH(NOEXPAND)
	where entryid=@postid
    
END
