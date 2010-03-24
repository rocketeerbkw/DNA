CREATE PROCEDURE contentsignifdecrementarticle 
	@siteid 	INT,
	@decrement	INT,
	@entryid 	INT = NULL 

AS
	/* 
		Decreases the significance score of all articles by @decrement.
		Delete rows from table is significance <= 0.
	*/
	UPDATE dbo.ContentSignifArticle
	   SET dbo.ContentSignifArticle.Score 	= dbo.ContentSignifArticle.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement 				= getdate()
	 WHERE SiteID = @siteid

	DELETE FROM dbo.ContentSignifArticle 
	 WHERE Score <= 3
	   AND SiteID = @siteid

RETURN 0