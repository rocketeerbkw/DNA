CREATE PROCEDURE addmodclassemailinsert @modclassid int, @name varchar(255), @group varchar(255), @text text
AS
BEGIN TRANSACTION
IF NOT EXISTS (SELECT * FROM EmailInserts WHERE ModClassID = @modclassid AND InsertName = @name)
BEGIN
	INSERT INTO EmailInserts (ModClassID, InsertName, InsertGroup, InsertText)
	VALUES (@modclassid, @name, @group, @text)
END
ELSE
BEGIN
	PRINT 'Row already exists'
END
COMMIT TRANSACTION