CREATE PROCEDURE getemailtemplatesbysiteid @siteid int
AS
BEGIN
DECLARE @modclassid int
SELECT @modclassid = (SELECT ModClassID FROM Sites WHERE SiteID = @siteid)
SELECT * FROM EmailTemplates WHERE ModClassID = @modclassid
END
