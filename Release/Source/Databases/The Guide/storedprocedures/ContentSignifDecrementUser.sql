CREATE PROCEDURE contentsignifdecrementuser 
	@siteid 	INT,
	@decrement 	INT,
	@userid 	INT = NULL
AS
	/* 
		Decreases the significance score of all users on a site by @decrement.
		Delete rows from table if significance <= 2.
	*/

	UPDATE dbo.ContentSignifUser
	   SET dbo.ContentSignifUser.Score	= dbo.ContentSignifUser.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement 			= getdate()
	 WHERE SiteID = @siteid

	DELETE FROM dbo.ContentSignifUser 
	 WHERE Score <= 3
	   AND SiteID = @siteid

RETURN 0