CREATE PROCEDURE getemailtemplatesbymodclassid @modclassid int
AS
IF (@modclassid = -1)
BEGIN
	SET @modclassid = (SELECT ModClassID FROM ModerationClass WHERE Name = 'Standard Universal')
END
SELECT * FROM EmailTemplates WHERE ModClassID = @modclassid
