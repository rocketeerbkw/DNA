CREATE     PROCEDURE getkeyarticlecomponents @articlename varchar(255), @siteid int = 1
AS
declare @entryid int
declare @editkey varchar(255)
SELECT TOP 1 @entryid = EntryID, @editkey = EditKey FROM KeyArticles WITH(NOLOCK)
	WHERE ArticleName = @articlename AND DateActive <= getdate() AND SiteID = @siteid
	ORDER BY DateActive DESC
SELECT 'EditKey' = @editkey, 
g.EntryID, 
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
g.LastUpdated,
'IsMainArticle' = 
	CASE EntryID
		WHEN @entryID THEN 1
		ELSE 0
	END,
g.ExtraInfo,
g.type,
g.text,
g.preprocessed,
g.ModerationStatus,
g.CanChangePermissions,
g.CanRead,
g.CanWrite 
FROM GuideEntries g WITH(NOLOCK)
WHERE g.EntryID = @entryid
/*
IN 
(SELECT g1.EntryID FROM GuideEntries g1, Inclusions i
WHERE (g1.EntryID = i.IncludesEntryID AND i.GuideEntryID = @entryid)
OR g1.EntryID = @entryid)
*/
