CREATE PROCEDURE movethreadfromsourcetodestinationnode @ithreadid int, @isourceid int, @idestinationid int
As

-- If it doesn't exist in source, or exists in destination, just return
IF NOT EXISTS (SELECT * FROM dbo.HierarchyThreadMembers WHERE threadID = @ithreadid and nodeid = @isourceid)
	OR EXISTS (SELECT * FROM dbo.HierarchyThreadMembers WHERE threadID = @ithreadid and nodeid = @idestinationid)
BEGIN
	SELECT 'Success'=0
	RETURN 0
END

DECLARE @ErrorCode INT

DECLARE @NodeName varchar(255)
DECLARE @ObjectName nvarchar(255)

SELECT @ObjectName = Subject FROM ThreadEntries WHERE ThreadID = @ithreadid AND PostIndex = 0
SELECT @NodeName = DisplayName FROM Hierarchy WHERE NodeID = @isourceid

BEGIN TRANSACTION

-- delete existing thread tag
DELETE FROM dbo.hierarchythreadmembers WHERE threadID = @ithreadid and nodeid = @isourceid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Decrement source count
UPDATE Hierarchy SET ThreadMembers = ThreadMembers-1 WHERE nodeid = @isourceid AND ThreadMembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Insert into source node
INSERT INTO dbo.hierarchythreadmembers(NodeID, ThreadId) VALUES (@idestinationid, @ithreadid)
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Increment destination count
UPDATE Hierarchy SET ThreadMembers = ISNULL(ThreadMembers,0)+1 WHERE nodeid = @idestinationid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Update Last Updated.
UPDATE Threads SET LastUpdated = getdate() WHERE ThreadID = @ithreadid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION

SELECT 'Success' = 1, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success'=0, 'ObjectName' = @ObjectName, 'NodeName' = @NodeName
RETURN @ErrorCode
