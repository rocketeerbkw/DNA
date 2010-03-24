CREATE PROCEDURE moveuserfromsourcetodestinationnode @iuserid int, @isourceid int, @idestinationid int
As
DECLARE @ErrorCode INT
SET @ErrorCode = 0

-- If it doesn't exist in source, or exists in destination, just return
IF NOT EXISTS (SELECT * FROM dbo.hierarchyusermembers WHERE userID = @iuserid and nodeid = @isourceid)
	OR EXISTS (SELECT * FROM dbo.hierarchyusermembers WHERE userID = @iuserid and nodeid = @idestinationid)
BEGIN
	SELECT 'Success'=0
	RETURN 0
END

DECLARE @NodeName varchar(255)
DECLARE @ObjectName varchar(255)

SELECT @ObjectName = UserName FROM Users WHERE UserID = @iuserid
SELECT @NodeName = DisplayName FROM Hierarchy WHERE NodeID = @isourceid
		
BEGIN TRANSACTION

-- Remove from source node
DELETE FROM dbo.hierarchyusermembers WHERE userid = @iuserid AND nodeid = @isourceid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Decrement count in source
UPDATE dbo.Hierarchy SET UserMembers = UserMembers-1 WHERE nodeid = @isourceid AND UserMembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Add to destination node
INSERT INTO dbo.hierarchyusermembers(NodeID, UserId) VALUES( @idestinationid, @iuserid)
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Increment destination count
UPDATE dbo.hierarchy SET UserMembers = ISNULL(UserMembers,0)+1 WHERE nodeid=@idestinationid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
		
COMMIT TRANSACTION

SELECT 'Success' = 1, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success'=0, 'ObjectName' = @ObjectName, 'NodeName' = @NodeName
RETURN @ErrorCode
