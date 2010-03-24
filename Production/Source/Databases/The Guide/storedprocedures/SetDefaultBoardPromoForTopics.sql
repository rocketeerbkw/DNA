CREATE PROCEDURE setdefaultboardpromofortopics @siteid int, @boardpromoid int, @userid int
AS
-- First make sure the promo belongs to the same site!!!
IF NOT EXISTS (SELECT * FROM dbo.BoardPromoElements bpe INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID WHERE fpe.SiteID = @siteid AND bpe.BoardPromoElementID = @boardpromoid )
BEGIN
	SELECT 'Exists' = 0
	RETURN 0
END

DECLARE @Error int
BEGIN TRANSACTION
	UPDATE dbo.Topics SET DefaultBoardPromoID = @boardpromoid, LastUpdated = GetDate(), UserUpdated = @userid
	WHERE SiteID = @siteid AND TopicStatus = 1
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION
SELECT 'Exists' = 1
