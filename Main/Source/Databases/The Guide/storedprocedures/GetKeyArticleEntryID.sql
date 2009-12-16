CREATE PROCEDURE getkeyarticleentryid @articlename VARCHAR(255), @siteid INT, @entryid INT OUTPUT
AS

SELECT TOP 1 @entryid = EntryID FROM dbo.KeyArticles 
	WHERE ArticleName = @articlename AND DateActive <= GETDATE() AND SiteID = @siteid
	ORDER BY DateActive DESC

SET @entryid = ISNULL(@entryid,0)
