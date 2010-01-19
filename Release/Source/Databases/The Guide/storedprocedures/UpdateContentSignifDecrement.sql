CREATE PROCEDURE updatecontentsignifdecrement 
	@actionid	INT, 
	@itemid		INT, 
	@siteid 	INT, 
	@decrement 	INT
AS
	
	IF (@@TRANCOUNT = 0)
	BEGIN
		/*
			N.B. This Stored procedure must not be called directly as it doesn't do any TRANSACTION handling.
			Make sure the calling procedure calls this within BEGIN / COMMIT TRANSACTION statements.
		*/
		RAISERROR ('updatecontentsignifdecrement cannot be called outside a transaction!!!',16,1)
		RETURN 50000
	END

	IF EXISTS(SELECT 1 FROM dbo.contentsignifdecrement WHERE ActionID = @actionid AND ItemID = @itemid AND SiteID = @siteid)
	BEGIN
		UPDATE dbo.contentsignifdecrement
		   SET Value	= @decrement 
		 WHERE ActionID	= @actionid
		   AND ItemID	= @itemid
		   AND SiteID	= @siteid
	END
	ELSE
	BEGIN
		INSERT INTO dbo.contentsignifdecrement
		(
			ActionID,
			ItemID, 
			SiteID, 
			Value
		)
		VALUES
		(
			@actionid, 
			@itemid,
			@siteid, 
			@decrement
		)
	END

RETURN @@ERROR