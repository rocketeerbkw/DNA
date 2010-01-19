CREATE PROCEDURE fetchguideentry @entryid int
AS
SELECT g.EntryID, g.blobid, g.DateCreated, g.DateExpired, g.Cancelled, 
g.SupercededBy, g.BasedOn, g.Editor, g.ForumID, g.Subject, g.Keywords, g.Type, 
g.LatestVersion, g.Style, g.Status, g.h2g2ID, g.text
FROM GuideEntries g WITH(NOLOCK)
WHERE g.EntryID = @entryid