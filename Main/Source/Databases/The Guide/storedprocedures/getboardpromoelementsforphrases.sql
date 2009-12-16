CREATE PROCEDURE getboardpromoelementsforphrases @siteid INT, @keyphraselist varchar(8000) = '', @elementstatus INT = 0
AS
BEGIN
	--Indicate empty keyphraselist.
	IF @keyphraselist = ''
	BEGIN
		SET @keyphraselist = '|'
	END
	
	DECLARE @phrases TABLE( phrase VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS)
	INSERT @phrases SELECT element 'phrase' FROM udf_splitvarchar(@keyphraselist)
	
	DECLARE @count INT; 
	SELECT @count = count(*) FROM @phrases

	SELECT	fpe.SiteID,
			fpe.ElementLinkID,
			fpe.ElementStatus,
			fpe.TemplateType,
			fpe.FrontPagePosition,
			fpe.Title,
			fpe.[Text],
			fpe.TextBoxType,
			fpe.TextBorderType,
			fpe.ImageName,
			fpe.ImageWidth,
			fpe.ImageHeight,
			fpe.EditKey,
			bpe.BoardPromoElementID,
			bpe.Name,
			fpe.ImageAltText,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.BoardPromoElements bpe WITH(NOLOCK) ON bpe.ElementID = fpe.ElementID
	INNER JOIN 
	(	
		--Get Board Promos that match on all of the phrases in keyphraselist.
		SELECT BoardPromoElementID
		 FROM BoardPromoElementKeyPhrases bpkp
		 INNER JOIN KeyPhrases kp ON kp.PhraseId = bpkp.PhraseId
		 INNER JOIN @phrases uv ON uv.phrase = kp.Phrase
		 GROUP BY BoardPromoElementID HAVING COUNT(bpkp.PhraseId) = @count
	) AS promofilter ON promofilter.BoardPromoElementID = bpe.BoardPromoElementID
	WHERE fpe.ElementStatus = @elementstatus AND fpe.SiteID = @siteid
	
	IF @@ROWCOUNT = 0 
	BEGIN
		-- Could Not Find and board promos for phrase specified - try to return a default.
		-- A default promo will be tagged to phraseId 0.
		SELECT	fpe.SiteID,
			fpe.ElementLinkID,
			fpe.ElementStatus,
			fpe.TemplateType,
			fpe.FrontPagePosition,
			fpe.Title,
			fpe.[Text],
			fpe.TextBoxType,
			fpe.TextBorderType,
			fpe.ImageName,
			fpe.ImageWidth,
			fpe.ImageHeight,
			fpe.EditKey,
			bpe.BoardPromoElementID,
			bpe.Name,
			fpe.ImageAltText,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID
			FROM dbo.FrontPageElements fpe WITH(NOLOCK)
			INNER JOIN dbo.BoardPromoElements bpe WITH(NOLOCK) ON bpe.ElementID = fpe.ElementID
			INNER JOIN dbo.BoardPromoElementKeyPhrases bpkp WITH (NOLOCK) ON bpkp.BoardPromoElementID = bpe.BoardPromoElementID AND bpkp.PhraseId = 0
			WHERE fpe.ElementStatus = @elementstatus AND fpe.SiteID = @siteid
	END
END