CREATE PROCEDURE getnumberofboardpromoelementsforsiteid @isiteid INT, @ielementstatus INT 
AS
BEGIN
	SELECT COUNT(*) AS "NumOfElements" 
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.BoardPromoElements bpe WITH(NOLOCK) ON bpe.ElementID = fpe.ElementID
	WHERE fpe.SiteID = @isiteid AND fpe.ElementStatus = @ielementstatus
END
