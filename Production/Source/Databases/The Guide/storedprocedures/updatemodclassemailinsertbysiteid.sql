CREATE PROCEDURE updatemodclassemailinsertbysiteid @siteid int, @name varchar(255), @group varchar(255), @text nvarchar(MAX)
AS
BEGIN
	DECLARE @modclassid int
	SET @modclassid = (SELECT modclassid FROM Sites WHERE siteid = @siteid)
	UPDATE dbo.EmailInserts 
	SET InsertGroup = @group, InsertText = @text
	WHERE ModClassID = @modclassid AND InsertName = @name

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO dbo.EmailInserts (ModClassID, InsertName, InsertText, InsertGroup)
		VALUES (@modclassid, @name, @text, @group)
	END
END