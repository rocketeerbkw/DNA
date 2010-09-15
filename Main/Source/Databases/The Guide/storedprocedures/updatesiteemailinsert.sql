CREATE PROCEDURE updatesiteemailinsert @siteid int, @name varchar(255), @group varchar(255), @text nvarchar(MAX), @reasondescription varchar(255) = NULL
AS
UPDATE EmailInserts 
SET InsertGroup = @group, InsertText = @text
WHERE SiteID = @siteid AND InsertName = @name
IF @@ROWCOUNT = 0
BEGIN
INSERT INTO EmailInserts(SiteID, InsertName, InsertGroup, InsertText) 
VALUES(@siteid, @name, @group, @text)
END