CREATE PROCEDURE getnumberoftextboxelementsforsiteid @isiteid INT, @ielementstatus INT 
AS
BEGIN
	SELECT COUNT(*) AS "NumOfElements" 
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.TextBoxElements te WITH(NOLOCK) ON te.ElementID = fpe.ElementID
	WHERE fpe.SiteID = @isiteid AND fpe.ElementStatus = @ielementstatus
END
