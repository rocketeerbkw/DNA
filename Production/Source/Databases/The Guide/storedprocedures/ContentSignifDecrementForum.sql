CREATE PROCEDURE contentsignifdecrementforum 
	@siteid 	INT,
	@decrement	INT,
	@forumid 	INT = NULL
AS
	/* 
		Decreases the significance of all forums on a site score by @decrement. 
		Delete rows from table if significance <= 0.
	*/
	UPDATE dbo.ContentSignifForum
	   SET dbo.ContentSignifForum.Score = dbo.ContentSignifForum.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement = getdate()
	 WHERE (ForumId = @forumid OR @forumid IS NULL)
	   AND SiteID = @siteid

	DELETE FROM ContentSignifForum 
	 WHERE Score <= 3
	   AND SiteID = @siteid

RETURN 0