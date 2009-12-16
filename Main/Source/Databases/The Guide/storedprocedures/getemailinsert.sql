CREATE PROCEDURE getemailinsert @siteid int, @insertname varchar(255)
AS
SELECT TOP 1 InsertText FROM EmailInserts 
WHERE ModClassID = (SELECT ModClassID FROM Sites WHERE SiteID = @siteid) AND InsertName = @insertname
OR SiteId = @siteid AND InsertName = @insertname
ORDER BY ModClassID