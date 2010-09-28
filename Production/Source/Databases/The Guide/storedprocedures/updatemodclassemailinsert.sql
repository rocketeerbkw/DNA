CREATE PROCEDURE updatemodclassemailinsert @modclassid int, @name varchar(255), @group varchar(255), @text nvarchar(MAX), @reasondescription varchar(255)
AS
UPDATE dbo.EmailInserts 
SET InsertGroup = @group, InsertText = @text
WHERE ModClassID = @modclassid AND InsertName = @name
if @@ROWCOUNT = 0
begin
	INSERT INTO EmailInserts(ModClassID, InsertName, InsertGroup, InsertText)
	VALUES (@modclassid, @name, @group, @text)
	declare @reasonid int
	select @reasonid = MAX(reasonid) from ModReason
	INSERT INTO ModReason (ReasonID, DisplayName, EmailName, EditorsOnly)
	VALUES (@reasonid + 1, @reasondescription, @name, 0)
end