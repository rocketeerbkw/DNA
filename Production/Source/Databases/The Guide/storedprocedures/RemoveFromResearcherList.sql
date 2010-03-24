/*
	Removes given user from the reseacher list for given article
*/

CREATE PROCEDURE removefromresearcherlist @h2g2id INT, @userid INT
AS

declare @rowsremoved int

DELETE FROM Researchers 
FROM Researchers r INNER JOIN GuideEntries ge ON r.EntryID = ge.EntryID 
WHERE ge.h2g2ID = @h2g2id AND r.UserID = @userid AND ge.Editor <> @userid

SELECT @rowsremoved = @@ROWCOUNT 

Update GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @h2g2id

SELECT 'Removed' = @rowsremoved