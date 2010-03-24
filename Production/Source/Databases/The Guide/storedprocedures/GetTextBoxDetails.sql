CREATE PROCEDURE gettextboxdetails @textboxelementid INT
AS
BEGIN	
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
			te.TextBoxElementID,
			fpe.ImageAltText,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.TextBoxElements te WITH(NOLOCK) ON te.ElementID = fpe.ElementID
	WHERE te.TextBoxElementID = @textboxelementid
END
