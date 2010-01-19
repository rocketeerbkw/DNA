CREATE PROCEDURE addresearcher @entryid int, @userid int
AS
INSERT INTO Researchers (EntryID, UserID) VALUES (@entryid, @userid)
