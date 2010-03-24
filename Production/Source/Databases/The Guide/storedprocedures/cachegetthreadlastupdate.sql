CREATE   PROCEDURE cachegetthreadlastupdate @threadid int
AS
	select max(lastupdated) as 'LastUpdated'
	from threads
	where threadid = @threadid
	