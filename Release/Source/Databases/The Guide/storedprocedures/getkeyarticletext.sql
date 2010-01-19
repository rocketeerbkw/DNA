CREATE PROCEDURE getkeyarticletext @articlename varchar(255), @siteid int = 1
AS
declare @entryid int
EXEC GetKeyArticleEntryID @articlename,@siteid, @entryid OUTPUT
	
SELECT g.text FROM dbo.GuideEntries g WHERE g.EntryID = @entryid
