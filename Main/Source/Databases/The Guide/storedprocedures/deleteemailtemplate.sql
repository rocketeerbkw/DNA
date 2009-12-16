CREATE PROCEDURE deleteemailtemplate @modclassid int, @templatename varchar(255)
AS
DELETE FROM EmailTemplates WHERE ModClassID = @modclassid AND Name = @templatename