CREATE PROCEDURE isarticleinmoderation @h2g2id INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
	
	DECLARE @ArticlesCurrentModStatus INT; 
	SELECT TOP 1 @ArticlesCurrentModStatus = Status
	  FROM dbo.ArticleMod
	 WHERE h2g2ID = @h2g2id
	   AND DateCompleted IS NOT NULL 
	 ORDER BY DateCompleted DESC

	DECLARE @IsArticleLockedOrReferred INT; 
	IF EXISTS (SELECT 1 
				 FROM dbo.ArticleMod
				WHERE h2g2ID = @h2g2id
				  AND DateCompleted IS NULL
				  AND ( 
						(Status = 2) OR -- referred
						(DateLocked IS NOT NULL AND LockedBy IS NOT NULL) -- locked by a moderator
					   ) 
			  )
	BEGIN
		SET @IsArticleLockedOrReferred = 1; 
	END
	ELSE 
	BEGIN 
		SET @IsArticleLockedOrReferred = 0; 
	END

	IF (@ArticlesCurrentModStatus = 4 OR -- failed moderation
		@IsArticleLockedOrReferred = 1)
	BEGIN
		SELECT 1 'InModeration'
	END
	ELSE 
	BEGIN
		SELECT 0 'InModeration'
	END

RETURN @@ERROR