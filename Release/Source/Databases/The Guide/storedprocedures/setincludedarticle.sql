CREATE PROCEDURE setincludedarticle @mainarticle int, @includes int
AS
INSERT INTO Inclusions (GuideEntryID, IncludesEntryID)
VALUES(@mainarticle, @includes)