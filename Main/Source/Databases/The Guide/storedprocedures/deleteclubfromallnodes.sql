/* Delete club from all hierarchy nodes */
CREATE PROCEDURE deleteclubfromallnodes @clubid int
As

DECLARE @ErrorCode INT

--Get the affected nodeids.
DECLARE @nodeids AS TABLE( nodeid INT )
INSERT INTO @nodeids SELECT nodeid FROM HierarchyClubMembers WHERE clubid = @clubid

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchyclubmembers WHERE ClubID = @clubid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


UPDATE [dbo].hierarchy
	SET clubmembers = clubmembers-1
	WHERE nodeid IN ( SELECT nodeid FROM @nodeids ) AND clubmembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


UPDATE [dbo].GuideEntries SET LastUpdated = getdate() 
FROM GuideEntries g
INNER JOIN Clubs c ON c.h2g2id = g.h2g2id AND c.clubid = @clubid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


COMMIT TRANSACTION

SELECT 'Success' = 1, 'ObjectName' = (SELECT g.Subject FROM guideentries g INNER JOIN clubs c ON c.h2g2id = g.h2g2id AND c.clubid = @clubid ), 'NodeName' = h.displayname
FROM Hierarchy h
INNER JOIN @nodeids n ON n.nodeid = h.nodeid

return(0)

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode