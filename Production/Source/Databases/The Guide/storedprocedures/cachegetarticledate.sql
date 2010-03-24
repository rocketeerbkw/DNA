CREATE PROCEDURE cachegetarticledate @h2g2id int
AS
	DECLARE @entryid int
	SELECT @entryid = @h2g2id / 10

SELECT 'seconds' = MIN(tval)-1 FROM
(
SELECT 'tval' = DATEDIFF(second, LastUpdated, getdate()) FROM GuideEntries g WITH(NOLOCK) WHERE g.h2g2id = @h2g2id
UNION
SELECT 'tval' = 60*60*24	-- don't cache longer than 24 hours
) t


/*
SELECT 'seconds' = MIN(tval)-1 FROM
(
SELECT 'tval' = DATEDIFF(second, MAX(DatePerformed), getdate()) FROM EditHistory WHERE EntryID = @entryid
UNION
SELECT 'tval' = DATEDIFF(second, DateCreated, getdate()) FROM GuideEntries g WHERE g.h2g2id = @h2g2id
UNION
SELECT 'tval' = 60*60*24	-- don't cache longer than 24 hours
) t
*/