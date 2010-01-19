CREATE PROCEDURE gettopicelementsforsite @siteid INT, @elementstatus INT, @elementstatus2 INT = NULL
AS
BEGIN	
	SELECT	fpe.SiteID,
			fpe.ElementLinkID,
			fpe.ElementStatus,
			fpe.FrontPagePosition,
			fpe.Title,
			fpe.[Text],
			fpe.TextBoxType,
			fpe.TextBorderType,
			fpe.TemplateType,
			fpe.ImageName,
			fpe.ImageWidth,
			fpe.ImageHeight,
			fpe.ImageAltText,
			fpe.EditKey,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID,
			t.h2g2ID,
			g.ForumID,
			'ForumPostCount' = fm.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = fm.ForumID),
			te.TopicID,
			te.TopicElementID
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.TopicElements te WITH(NOLOCK) ON te.ElementID = fpe.ElementID
	LEFT JOIN dbo.Topics AS t WITH(NOLOCK) ON t.TopicID = te.TopicID
	LEFT JOIN dbo.GuideEntries AS g WITH(NOLOCK) ON g.h2g2ID = t.h2g2ID
	LEFT JOIN dbo.Forums AS fm WITH(NOLOCK) ON g.ForumID = fm.ForumID
	WHERE fpe.ElementStatus IN (@elementstatus,ISNULL(@elementstatus2,@elementstatus)) AND fpe.SiteID = @siteid
END
