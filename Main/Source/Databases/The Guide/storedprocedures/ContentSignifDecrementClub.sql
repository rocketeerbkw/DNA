CREATE PROCEDURE contentsignifdecrementclub 
	@siteid 	INT,
	@decrement	INT,
	@clubid 	INT = NULL
AS
	/* 
		Decreases the significance score of all clubs on a site by @decrement. 
		Delete rows from table if significance <= 0.
	*/
	UPDATE dbo.ContentSignifClub
	   SET dbo.ContentSignifClub.Score 	= dbo.ContentSignifClub.Score * ((100 - @decrement)/100.0), 
		   ScoreLastDecrement 			= getdate()
   	 WHERE (ClubId = @clubid OR @clubid IS NULL)
	   AND SiteID = @siteid

	DELETE FROM ContentSignifClub 
	 WHERE Score <= 3
	   AND SiteID = @siteid

RETURN 0