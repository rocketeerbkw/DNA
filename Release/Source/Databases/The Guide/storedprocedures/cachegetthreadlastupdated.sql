CREATE   PROCEDURE cachegetthreadlastupdated  @threadid INT, @lastupdated INT OUTPUT  
AS
	DECLARE @ErrorCode INT
	
	select @lastupdated = ISNULL(DATEDIFF(second, LastUpdated, getdate()),60*60*12)
	FROM Threads WITH(NOLOCK)
	WHERE threadid = @threadid
	
	RETURN @@ERROR
