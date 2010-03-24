/* Adds a comma separated list of users to the hierarchy. */
CREATE PROCEDURE adduserstohierarchy @nodeid INT, @userlist VARCHAR(255)
AS

DECLARE @Success INT
DECLARE @Duplicate INT
DECLARE @ErrorCode INT

BEGIN TRANSACTION

DECLARE @userid iNT
DECLARE user_cursor CURSOR DYNAMIC FOR
SELECT userid
FROM Users u WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@userlist) s ON s.element = u.userid

OPEN user_cursor
FETCH NEXT FROM user_cursor INTO @userid
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @success = 1
	SET @duplicate = 0
	IF EXISTS ( SELECT userid FROM HierarchyUserMembers hu WHERE hu.NodeId = @nodeid AND hu.userid = @userid ) 
	BEGIN
		SET @success = 0
		SET @duplicate = 1
	END 

	IF @duplicate = 0
	BEGIN
		INSERT INTO dbo.hierarchyusermembers(NodeID, UserId) VALUES( @nodeid, @userid)
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET UserMembers = ISNULL(UserMembers,0)+1 WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
		
		-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
		EXEC addtoeventqueueinternal 'ET_CATEGORYUSERTAGGED', @nodeid, 'IT_NODE', DEFAULT, DEFAULT, @userid
	
	END

	--Use multiple resultsets - one resultset for each record processed.
	SELECT 'Success' = @Success,
			'Duplicate' = @Duplicate, 
			'ObjectName' = u.UserName, 
			'UserId' = u.userId,
			( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName
			FROM [dbo].Users u
			WHERE u.UserId = @userId
	FETCH NEXT FROM user_cursor INTO @userid
END

COMMIT TRANSACTION

CLOSE user_cursor
DEALLOCATE user_cursor

RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE user_cursor
DEALLOCATE user_cursor
SELECT 'Success' = 0
RETURN @ErrorCode
