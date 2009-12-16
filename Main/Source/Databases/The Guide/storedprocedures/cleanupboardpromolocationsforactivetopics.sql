CREATE PROCEDURE cleanupboardpromolocationsforactivetopics @siteid int
AS
DECLARE @Error int
BEGIN TRANSACTION
	-- Set active topic boardpromoids to 0 where the preview topics boardpromoids are 0
	UPDATE dbo.Topics SET BoardPromoID = 0
	FROM
	(
		SELECT TopicLinkID FROM dbo.Topics WHERE SiteID = @siteid AND TopicStatus = 1 AND BoardPromoID = 0
	)
	AS t1
	WHERE dbo.Topics.TopicID = t1.TopicLinkID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Get the default board promoid from one of the preview topics
	DECLARE @DefaultPreviewPromoID int, @DefaultActivePromoID int
	SELECT @DefaultPreviewPromoID = DefaultBoardPromoID FROM dbo.Topics WHERE TopicStatus = 1 AND SiteID = @siteid

	-- Now get the active boardpromoid that links to the preview boardpromo
	SELECT @DefaultActivePromoID = bpe2.BoardPromoElementID FROM BoardPromoElements bpe
	INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID
	INNER JOIN dbo.BoardPromoElements bpe2 ON bpe2.ElementID = fpe.ElementLinkID
	WHERE bpe.BoardPromoElementID = @DefaultPreviewPromoID
	
	-- Now set all the active topics for the given site to the default active boardpromoid
	UPDATE dbo.Topics SET DefaultBoardPromoID = ISNULL(@DefaultActivePromoID,0)
	WHERE TopicStatus = 0 AND SiteID = @siteid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

COMMIT TRANSACTION
