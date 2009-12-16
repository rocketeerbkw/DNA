CREATE PROCEDURE addusertohierarchy @nodeid INT, @userid INT
AS

DECLARE @Success INT
SET @Success = 1
DECLARE @Duplicate INT
SET @Duplicate = 0

DECLARE @ErrorCode INT

IF NOT EXISTS (SELECT * from dbo.hierarchyusermembers where nodeid=@nodeid AND userid=@userid)
BEGIN
	BEGIN TRANSACTION 
	
	INSERT INTO dbo.hierarchyusermembers(NodeID, UserId) VALUES( @nodeid, @userid)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE hierarchy SET UserMembers = ISNULL(UserMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYUSERTAGGED', @nodeid, 'IT_NODE', DEFAULT, DEFAULT, @userid
	
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

Select 'Success' = @Success,'Duplicate' = @Duplicate, 'ObjectName' = u.UserName, 'NodeName' = h.DisplayName 
			FROM [dbo].Users u
			INNER JOIN Hierarchy h ON h.NodeID = @nodeid
			WHERE u.UserId = @userId

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode
