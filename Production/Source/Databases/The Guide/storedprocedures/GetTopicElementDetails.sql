CREATE PROCEDURE gettopicelementdetails @topicelementid INT
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
			fpe.ImageAltText,
			fpe.LastUpdated,
			fpe.DateCreated,
			fpe.UserID,
			fpe.EditKey,
			t.h2g2ID,
			g.forumID,
			'ForumPostCount' = fm.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = fm.ForumID),
			te.TopicID,
			te.TopicElementID
	FROM dbo.FrontPageElements fpe WITH(NOLOCK)
	INNER JOIN dbo.TopicElements te WITH(NOLOCK) ON te.ElementID = fpe.ElementID
	LEFT JOIN dbo.Topics AS t WITH(NOLOCK) ON t.TopicID = te.TopicID
	LEFT JOIN dbo.GuideEntries AS g WITH(NOLOCK) ON g.h2g2ID = t.h2g2ID
	LEFT JOIN dbo.forums AS fm WITH(NOLOCK) ON g.ForumID = fm.ForumID
	WHERE te.TopicElementID = @topicelementid
END
