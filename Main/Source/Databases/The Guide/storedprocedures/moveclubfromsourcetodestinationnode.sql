CREATE PROCEDURE moveclubfromsourcetodestinationnode @iclubid int, @isourceid int, @idestinationid int
As
DECLARE @ErrorCode INT
DECLARE @NodeName varchar(255)
DECLARE @ObjectName varchar(255)
DECLARE @h2g2id int

-- If it doesn't exist in source, or exists in destination, just return
IF NOT EXISTS (SELECT * FROM dbo.HierarchyClubMembers WHERE ClubId = @iclubid and nodeid = @isourceid)
	OR EXISTS (SELECT * FROM dbo.HierarchyClubMembers WHERE ClubId = @iclubid and nodeid = @idestinationid)
BEGIN
	SELECT 'Success'=0
	RETURN 0
END

SELECT @ObjectName = g.Subject, @h2g2id = g.h2g2ID FROM GuideEntries g
	INNER JOIN Clubs c ON c.h2g2id = g.h2g2id AND c.clubid = @iclubid
			
SELECT @NodeName = DisplayName FROM Hierarchy WHERE NodeID = @isourceid
						
BEGIN TRANSACTION

-- Remove from source node
DELETE FROM HierarchyClubMembers WHERE ClubID = @iclubid AND NodeID = @isourceid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Decrement count in source
UPDATE Hierarchy SET ClubMembers = ClubMembers-1 WHERE NodeID = @isourceid AND ClubMembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Add to destination node
INSERT INTO HierarchyClubMembers(ClubID,NodeID) VALUES (@iclubid,@idestinationid)
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Increment count in destination
UPDATE Hierarchy SET ClubMembers = ISNULL(ClubMembers,0)+1 WHERE NodeID = @idestinationid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

--Update Last Updated, to force cached article data to expire
UPDATE GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION
SELECT 'Success' = 1, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN @ErrorCode
