CREATE PROCEDURE addnewemailtemplate @modclassid int, @name varchar(255), @subject nvarchar(255), @body nvarchar(MAX)
AS
IF NOT EXISTS (SELECT * FROM EmailTemplates WHERE ModClassID = @modclassid AND Name = @name)
BEGIN
	INSERT INTO EmailTemplates(ModClassID, Name, Subject, Body) VALUES (@modclassid, @name, @subject, @body)
END