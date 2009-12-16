CREATE PROCEDURE getarticlecomponents2 @entryid int
AS

DECLARE @NumLocations int
SELECT @NumLocations = count(*) FROM ArticleLocation WITH(NOLOCK) WHERE EntryID = @entryid

SELECT	g.EntryID, 
		g.blobid, 
		g.DateCreated, 
		g.DateExpired, 
		g.Subject, 
		g.ForumID, 
		g.h2g2ID, 
		g.Editor, 
		g.Status,
		g.Style,
		g.Hidden,
		g.SiteID,
		g.Submittable,
		g.ExtraInfo,
		g.Type,
		g.LastUpdated,
		'IsMainArticle' = CASE g.EntryID
			WHEN @entryID THEN 1
			ELSE 0
			END,
		g.text,
		g.ModerationStatus,
		g.PreProcessed,
		g.CanRead,
		g.CanWrite,
		g.CanChangePermissions,
		t.TopicID,
		'BoardPromoID' = CASE WHEN t.BoardPromoID = 0 THEN t.DefaultBoardPromoID ELSE t.BoardPromoID END,
		ar.StartDate,
		ar.EndDate,
		ar.TimeInterval,
		@NumLocations as 'LocationCount'
FROM dbo.GuideEntries g WITH(NOLOCK)
LEFT JOIN dbo.Topics t WITH(NOLOCK) ON t.h2g2ID = g.h2g2ID
LEFT JOIN dbo.ArticleDateRange ar WITH(NOLOCK) on ar.EntryID = g.EntryID
WHERE g.EntryID  = @entryid 

