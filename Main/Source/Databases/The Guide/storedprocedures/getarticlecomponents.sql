CREATE     PROCEDURE getarticlecomponents @entryid int
AS
SELECT g.EntryID, 
g.blobid, 
g.DateCreated, 
g.DateExpired, 
g.Subject, 
g.ForumID, 
g.h2g2ID, 
g.Editor, 
g.Status,
g.Style,
g.Type,
'IsMainArticle' = 
	CASE EntryID
		WHEN @entryID THEN 1
		ELSE 0
	END,
g.text
FROM GuideEntries g
WHERE g.EntryID  = @entryid 
/*
 IN 
(SELECT g1.EntryID FROM GuideEntries g1, Inclusions i
WHERE (g1.EntryID = i.IncludesEntryID AND i.GuideEntryID = @entryid)
OR g1.EntryID = @entryid)

*/

