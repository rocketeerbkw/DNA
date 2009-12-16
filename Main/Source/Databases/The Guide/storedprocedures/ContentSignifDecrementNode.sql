CREATE PROCEDURE contentsignifdecrementnode 
	@siteid 	INT, 
	@decrement	INT,
	@nodeid 	INT = NULL
AS
	/* 
		Decreases the significance of all nodes on a site by @decrement. 
		Delete rows from table if significance <= 0.
	*/
	UPDATE dbo.ContentSignifNode
	   SET dbo.ContentSignifNode.Score 	= dbo.ContentSignifNode.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement 			= getdate()
	 WHERE (NodeId = @nodeid OR @nodeid IS NULL)
	   AND SiteID = @siteid 

	DELETE FROM dbo.ContentSignifNode 
	 WHERE Score <= 3
	   AND SiteID = @siteid
	
RETURN 0