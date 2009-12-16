CREATE  PROCEDURE favouritearticles @userid int
AS
SELECT g.EntryID, Subject FROM GuideEntries g, Favourites f 
WHERE f.EntryID = g.EntryID AND f.UserID = @userid
