CREATE PROCEDURE fetchresearchers @entryid int
AS
SELECT UserID From Researchers WHERE EntryID = @entryid