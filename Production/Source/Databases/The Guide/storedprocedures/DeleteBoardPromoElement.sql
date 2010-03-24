CREATE PROCEDURE deleteboardpromoelement @boardpromoelementid int, @userid INT
AS
-- Check to make sure we're actually going to delete something!
IF NOT EXISTS ( SELECT * FROM dbo.BoardPromoElements WHERE BoardPromoElementID = @boardpromoelementid )
BEGIN
	SELECT 'ValidID' = 0
	RETURN 0
END

-- Get the current status of the Element, and work out the correct new status
DECLARE @Error int, @Status int, @LinkElementID int, @ElementID int
SELECT @ElementID = bpe.ElementID, @Status = fpe.ElementStatus, @LinkElementID = fpe.ElementLinkID FROM dbo.FrontPageElements fpe
INNER JOIN dbo.BoardPromoElements bpe ON bpe.ElementID = fpe.ElementID
WHERE bpe.BoardPromoElementID = @boardpromoelementid

-- Now call the internal delete procedure
DECLARE @ValidID int
BEGIN TRANSACTION
	EXEC @Error = DeleteFrontPageElementInternal @ElementID, @Status, @LinkElementID, @userid, @ValidID OUTPUT
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error);
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	--Reset Board Promo Name.
	UPDATE BoardPromoElements SET Name = '' WHERE BoardPromoElementID = @boardpromoelementid
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Now set any topic referencing this to 0
	UPDATE dbo.Topics SET BoardPromoID = 0 WHERE BoardPromoID = @boardpromoelementid
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Now do the same for the default promo
	UPDATE dbo.Topics SET DefaultBoardPromoID = 0 WHERE DefaultBoardPromoID = @boardpromoelementid
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	--delete and associations between the promo and any keyphrases.
	DELETE FROM boardpromoelementkeyphrases WHERE boardpromoelementid = @boardpromoelementid
	SELECT @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
COMMIT TRANSACTION
SELECT 'ValidID' = @ValidID