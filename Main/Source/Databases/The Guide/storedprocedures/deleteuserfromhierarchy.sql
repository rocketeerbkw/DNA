CREATE PROCEDURE deleteuserfromhierarchy @userid int, @nodeid int
As

DECLARE @Subject varchar(255)
DECLARE @NodeName varchar(255)
SELECT @Subject = u.UserName, @NodeName = h.DisplayName FROM [dbo].Users u
		INNER JOIN [dbo].Hierarchy h ON h.NodeID = @nodeId  
		WHERE u.UserId=@userid

DECLARE @ErrorCode INT
DECLARE @Success INT

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchyusermembers	WHERE userID = @userid and nodeid = @nodeid
IF ( @@ERROR <> 0 OR @@ROWCOUNT = 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Error'=@ErrorCode,'Success'=0, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END 

UPDATE [dbo].Hierarchy
	SET UserMembers = ((SELECT UserMembers From [dbo].Hierarchy h WITH(UPDLOCK) WHERE h.nodeid = @nodeid) - 1) 
	WHERE nodeid = @nodeid AND UserMembers > 0
IF ( @@ERROR <> 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	Select 'Error'=@ErrorCode,'Success'=0, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

COMMIT TRANSACTION


SELECT 'Success' = 1, 'ObjectName' = @Subject, 'NodeName' = @NodeName