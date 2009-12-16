CREATE PROCEDURE getemailtemplateidbyname @templatename varchar(255), @viewid int, @viewtype varchar(50)
AS
BEGIN
DECLARE @modclassid int
IF @viewtype = 'class'
BEGIN
	SET @modclassid = @viewid
END
ELSE IF @viewtype = 'site'
	
	SET @modclassid = (SELECT ModClassID FROM Sites WHERE SiteID = @viewid)
BEGIN
	SELECT EmailTemplateID FROM EmailTemplates WHERE ModClassID = @modclassid AND Name = @templatename
END
END