CREATE PROCEDURE contentsignifdecrementthread 
	@siteid 	INT,
	@decrement	INT,
	@threadid 	INT = NULL
AS
	/* 
		Decreases the significance of all threads on a site by @decrement.
		Delete rows from table if significance <= 0.
	*/
	UPDATE dbo.ContentSignifThread
	   SET dbo.ContentSignifThread.Score 	= dbo.ContentSignifThread.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement 				= getdate()
	 WHERE (ThreadId = @threadid OR @threadid IS NULL)
	   AND SiteID = @siteid

	DELETE FROM dbo.ContentSignifThread 
	 WHERE Score <= 3
	   AND SiteID = @siteid

RETURN 0