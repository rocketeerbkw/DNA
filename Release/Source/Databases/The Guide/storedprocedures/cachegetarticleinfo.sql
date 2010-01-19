CREATE PROCEDURE cachegetarticleinfo @h2g2id INT
AS

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

DECLARE @Seconds INT
SELECT @Seconds = MIN(t.tval)-1 FROM
(
	SELECT 'tval' = DATEDIFF(second, g.LastUpdated, getdate())
		FROM dbo.GuideEntries g WITH(NOLOCK)
		WHERE g.EntryID = @EntryID
	UNION ALL
	SELECT 'tval' = 60*60*24	-- don't cache longer than 24 hours
) t

SELECT 'Seconds' = @Seconds,
	'TopicID' = ISNULL(t.TopicID,0),
	'BoardPromoID' = ISNULL(t.BoardPromoID,0),
	'DefaultBoardPromoID' = ISNULL(t.DefaultBoardPromoID,0)
	FROM dbo.GuideEntries g WITH(NOLOCK)
	LEFT JOIN dbo.Topics t WITH(NOLOCK) ON t.h2g2ID = g.h2g2ID
	WHERE g.EntryID = @EntryID
