CREATE PROCEDURE getentryeditor	@entryid int
AS

SELECT EditorID FROM EditQueue WHERE EntryID = @entryid