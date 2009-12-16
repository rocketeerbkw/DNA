CREATE PROCEDURE deletenamespaceandassociatedlinks @namespaceid INT, @siteid INT
AS
IF EXISTS ( SELECT * FROM dbo.NameSpaces WHERE SiteID = @SiteID AND NameSpaceID = @NameSpaceID )
BEGIN
	BEGIN TRANSACTION
	DECLARE @Error INT
	-- Remove all article referencing the namespace
	DELETE FROM dbo.ArticleKeyPhrases WHERE PhraseNameSpaceID IN
		(
			SELECT PhraseNameSpaceID FROM dbo.PhraseNameSpaces pns
				INNER JOIN dbo.NameSpaces ns ON ns.NameSpaceID = pns.NameSpaceID AND ns.SiteID = @SiteID
			WHERE ns.NameSpaceID = @NameSpaceID
		)
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	DELETE FROM dbo.ArticleKeyPhrasesNonVisible WHERE PhraseNameSpaceID IN
		(
			SELECT PhraseNameSpaceID FROM dbo.PhraseNameSpaces pns
				INNER JOIN dbo.NameSpaces ns ON ns.NameSpaceID = pns.NameSpaceID AND ns.SiteID = @SiteID
			WHERE ns.NameSpaceID = @NameSpaceID
		)
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Remove all namespace pairs associated with the given name space
	DELETE FROM dbo.PhraseNameSpaces WHERE PhraseNameSpaceID IN
		(
			SELECT PhraseNameSpaceID FROM dbo.PhraseNameSpaces pns
				INNER JOIN dbo.NameSpaces ns ON ns.NameSpaceID = pns.NameSpaceID AND ns.SiteID = @SiteID
			WHERE ns.NameSpaceID = @NameSpaceID
		)
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	-- Remove the name space from the name spaces table
	DELETE FROM dbo.NameSpaces WHERE NameSpaceID = @NameSpaceID AND SiteID = @SiteID
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	COMMIT TRANSACTION
END