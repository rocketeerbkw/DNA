CREATE PROCEDURE gettextboxelementsforphrases @siteid INT, @keyphraselist varchar(8000) = '', @elementstatus INT = 0
AS
BEGIN	
	--Indicate empty keyphraselist.
	IF @keyphraselist = ''
	BEGIN
		SET @keyphraselist = '|'
	END
	
	DECLARE @count INT; 
	SELECT @count = count(*) FROM udf_splitvarchar(@keyphraselist)

	SELECT 		fpe.SiteID,
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
			tbe.TextBoxElementID,
			fpe.ImageAltText
	FROM [dbo].FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN [dbo].TextBoxElements tbe WITH(NOLOCK) ON tbe.ElementID = fpe.ElementID
	INNER JOIN [dbo].TextBoxElementKeyPhrases tbekp WITH (NOLOCK) ON tbekp.TextBoxElementID = tbe.TextBoxElementID
	INNER JOIN
	(
		select PhraseId
		FROM udf_splitvarchar(@keyphraselist) as s 
		INNER JOIN KeyPhrases kp ON s.element = kp.Phrase
		GROUP By PhraseId HAVING count(kp.PhraseID) = @count 
	) AS phrases ON phrases.PhraseId = tbekp.PhraseId
	WHERE fpe.ElementStatus = @elementstatus AND fpe.SiteID = @siteid
END
