CREATE PROCEDURE cachegetarticleinfo2 @h2g2id INT
AS

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

SELECT g.LastUpdated
FROM dbo.GuideEntries g WITH(NOLOCK)
WHERE g.EntryID = @EntryID