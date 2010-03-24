CREATE PROCEDURE cachegetkeyarticledate @artname varchar(255), @siteid int = 1
AS
declare @entryid int
SELECT TOP 1 @entryid = EntryID FROM KeyArticles WITH(NOLOCK) 
	WHERE ArticleName = @artname AND DateActive <= getdate() AND SiteID = @siteid
	ORDER BY DateActive DESC
SELECT 'seconds' = MIN(tval)-1 FROM
(
	SELECT 'tval' = DATEDIFF(second, MAX(DateActive), getdate()) FROM KeyArticles WITH(NOLOCK) WHERE ArticleName = @artname AND DateActive <= getdate()
UNION ALL
SELECT 'tval' = DATEDIFF(second, MAX(DatePerformed), getdate()) FROM EditHistory WITH(NOLOCK) WHERE EntryID = @entryid
UNION ALL
SELECT 'tval' = DATEDIFF(second, CASE WHEN DateCreated > LastUpdated THEN DateCreated ELSE LastUpdated END, getdate()) FROM GuideEntries g WITH(NOLOCK) WHERE g.Entryid = @entryid
UNION ALL
SELECT 'tval' = 60*60*24 -- don't cache anything over 24 hours old
) t