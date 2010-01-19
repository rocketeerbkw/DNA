CREATE PROCEDURE deletethreadfromhierarchy @threadid int, @nodeid int
As

DECLARE @Subject varchar(255)
DECLARE @NodeName varchar(255)
SELECT @Subject = t.FirstSubject, @NodeName = h.DisplayName FROM [dbo].Threads t
		INNER JOIN [dbo].Hierarchy h ON h.NodeID = @nodeId  
		WHERE t.ThreadId=@threadid

DECLARE @ErrorCode INT
DECLARE @Success INT

-- Dont open another transaction if one is already open.
DECLARE @usetransaction INT 
SET @usetransaction = 0 

IF @@TRANCOUNT = 0
BEGIN
	BEGIN TRANSACTION
	SET @usetransaction = 1
END

DELETE FROM [dbo].hierarchythreadmembers	WHERE threadID = @threadid and nodeid = @nodeid
IF ( @@ERROR <> 0 OR @@ROWCOUNT = 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	IF @usetransaction = 1
		ROLLBACK TRANSACTION
	Select 'Error'=@ErrorCode,'Success'=0, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END 

UPDATE [dbo].Hierarchy
	SET ThreadMembers = ((SELECT ThreadMembers From [dbo].Hierarchy h WITH(UPDLOCK) WHERE h.nodeid = @nodeid) - 1) 
	WHERE nodeid = @nodeid AND ThreadMembers > 0
IF ( @@ERROR <> 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	IF @usetransaction = 1
		ROLLBACK TRANSACTION
	Select 'Error'=@ErrorCode,'Success'=0, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

--Only return results if not nested.
IF @usetransaction = 1
	COMMIT TRANSACTION

--Invalidate Thread Cache.
UPDATE Threads SET LastUpdated = getdate() WHERE threadid = @threadid

SELECT 'Success' = 1, 'ObjectName' = @Subject, 'NodeName' = @NodeName