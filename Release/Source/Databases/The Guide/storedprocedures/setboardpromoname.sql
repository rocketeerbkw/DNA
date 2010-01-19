CREATE PROCEDURE setboardpromoname @promoid int, @name varchar(256), @editkey uniqueidentifier
AS
DECLARE @CurrentEditKey uniqueidentifier, @ElementID int, @Error int, @NewEditKey uniqueidentifier, @SiteID int, @Duplicates int

-- Now check to make sure the editkey matches
SELECT @CurrentEditKey = fpe.EditKey, @ElementID = fpe.ElementID, @SiteID = fpe.SiteID FROM dbo.BoardPromoElements bpe
INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID
WHERE bpe.BoardPromoElementID = @promoid

-- Now check to make sure we've actually found a valid board promo
IF (@ElementID IS NULL)
BEGIN
	SELECT 'ValidID' = 0
	RETURN 0
END

-- Now compare edit keys
IF (@CurrentEditKey != @editkey)
BEGIN
	SELECT 'ValidID' = 2
	RETURN 0
END

-- Now Check for duplicates
SELECT @Duplicates = COUNT(*) FROM dbo.BoardPromoElements bpe
INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID
WHERE bpe.Name = @name AND fpe.ElementStatus = 1 AND fpe.SiteID = @SiteID AND bpe.BoardPromoElementID <> @promoid
IF (@Duplicates > 0)
BEGIN
	SELECT 'ValidID' = 3
	RETURN 0
END

BEGIN TRANSACTION
	-- Update the promos name
	UPDATE dbo.BoardPromoElements SET Name = @name WHERE BoardPRomoElementID = @promoid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Update the EditKey for the promo
	SELECT @NewEditKey = NewID()
	UPDATE dbo.FrontPageelements SET EditKey = @NewEditKey WHERE ElementID = @ElementID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION
SELECT 'ValidID' = 1, 'NewEditKey' = @NewEditKey