CREATE Procedure doupdateuseradd @nodeid int, @useradd tinyint
As
	declare @existingNodeId int

	DECLARE @ErrorCode INT
	BEGIN TRANSACTION
	SELECT @existingNodeId = NodeID FROM Hierarchy WITH(UPDLOCK) WHERE NodeID = @nodeid 

	/* Only update if the nodeid exists */
	IF (@existingNodeId IS NOT NULL)
	Begin
  	   UPDATE Hierarchy
		SET UserAdd = @useradd
		WHERE NodeID = @nodeid 
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'NodeID' = NULL
			RETURN @ErrorCode
		END

		SELECT 'NodeID' = @nodeid
	END
 	ELSE
	 BEGIN
	   SELECT 'NodeID' = NULL
  	 END
	COMMIT TRANSACTION
	 return(0)