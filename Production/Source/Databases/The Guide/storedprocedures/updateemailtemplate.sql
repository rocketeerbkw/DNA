CREATE PROCEDURE updateemailtemplate @modclassid int, @name varchar(255), @subject nvarchar(255), @body nvarchar(MAX)
AS
IF EXISTS(SELECT * FROM EmailTemplates WHERE ModClassID = @modclassid AND Name = @name)
BEGIN
	UPDATE EmailTemplates SET Subject = @subject, Body = @body WHERE ModClassID = @modclassid AND Name = @name
END
ELSE
BEGIN
	EXEC addnewemailtemplate @modclassid, @name, @subject, @body
END