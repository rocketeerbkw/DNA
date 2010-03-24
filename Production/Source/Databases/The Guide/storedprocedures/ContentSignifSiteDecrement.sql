CREATE PROCEDURE contentsignifsitedecrement @siteid INT
AS
	DECLARE @ErrorCode	INT

	EXEC @ErrorCode = updatecontentsignif @activitydesc	= 'Batch Decrement', 
										  @siteid 		= @siteid

RETURN 0 
