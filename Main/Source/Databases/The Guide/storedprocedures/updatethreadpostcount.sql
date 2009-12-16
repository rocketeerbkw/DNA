--updates the counter maintained for thread entries
--@ichange can be positive ( 1 or above ) or negative (-1 or less)
--@ithreadid is the id of the thread whose counter is being updated
CREATE PROCEDURE  updatethreadpostcount @ithreadid INT, @ichange INT 
AS
BEGIN 
	BEGIN TRANSACTION

	UPDATE dbo.Threads
	SET ThreadPostCount = ThreadPostCount + @ichange
	WHERE ThreadID = @ithreadid
	
	IF (@@ERROR <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @@ERROR			
		RETURN @@ERROR
	END

	COMMIT TRANSACTION
END 
