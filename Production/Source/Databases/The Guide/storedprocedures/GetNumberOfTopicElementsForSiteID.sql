CREATE PROCEDURE getnumberoftopicelementsforsiteid @isiteid INT, @ielementstatus INT 
AS
BEGIN
	SELECT COUNT(*) AS "NumOfElements" 
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.TopicElements te WITH(NOLOCK) ON te.ElementID = fpe.ElementID
	WHERE fpe.SiteID = @isiteid AND fpe.ElementStatus = @ielementstatus
END
