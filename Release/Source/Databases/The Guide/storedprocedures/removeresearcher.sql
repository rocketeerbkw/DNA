CREATE PROCEDURE removeresearcher @entryid int, @userid int
AS

DELETE FROM Researchers WHERE EntryID = @entryid AND UserID = @userid