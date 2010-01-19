CREATE   PROCEDURE cachegetthreadlastupdate @threadid int
AS
	select lastupdated 
	from threads
	where threadid = @threadid
	