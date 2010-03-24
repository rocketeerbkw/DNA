CREATE   PROCEDURE cachegetforumlastupdate @forumid int
AS
	
	declare @forumlastupdate datetime
	select @forumlastupdate = ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime))
	FROM dbo.ForumLastUpdated
	where forumid = @forumid

	select ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime)) as 'threadlastupdated',
	@forumlastupdate as 'forumlastupdated' 
	from threads
	where forumid = @forumid
	