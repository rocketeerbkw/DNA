CREATE PROCEDURE getboardpromoelementsforsite @siteid INT, @elementstatus INT, @elementstatus2 INT = NULL
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
			bpe.BoardPromoElementID,
			bpe.Name,
			fpe.ImageAltText,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.BoardPromoElements bpe WITH(NOLOCK) ON bpe.ElementID = fpe.ElementID
	WHERE fpe.ElementStatus IN (@elementstatus,ISNULL(@elementstatus2,@elementstatus)) AND fpe.SiteID = @siteid
END
