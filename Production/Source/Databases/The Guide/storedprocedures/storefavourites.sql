CREATE  PROCEDURE storefavourites @userid int, @articleid int
AS
IF NOT EXISTS(SELECT * FROM Favourites WHERE UserID = @userid AND EntryID = @articleid)
INSERT INTO Favourites (UserID, EntryID) VALUES(@userid, @articleid)
