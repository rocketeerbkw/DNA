CREATE PROCEDURE addresearchers @entryid int, 
@rid1 int = NULL, 
@rid2 int = NULL, 
@rid3 int = NULL, 
@rid4 int = NULL, 
@rid5 int = NULL, 
@rid6 int = NULL, 
@rid7 int = NULL, 
@rid8 int = NULL, 
@rid9 int = NULL, 
@rid10 int = NULL

AS
IF (NOT (@rid1 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid1)
IF (NOT (@rid2 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid2)
IF (NOT (@rid3 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid3)
IF (NOT (@rid4 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid4)
IF (NOT (@rid5 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid5)
IF (NOT (@rid6 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid6)
IF (NOT (@rid7 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid7)
IF (NOT (@rid8 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid8)
IF (NOT (@rid9 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid9)
IF (NOT (@rid10 IS NULL))
INSERT INTO Researchers (EntryID, UserID) VALUES(@entryid, @rid10)
