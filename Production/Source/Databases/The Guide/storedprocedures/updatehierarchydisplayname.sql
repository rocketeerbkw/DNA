CREATE Procedure updatehierarchydisplayname @nodeid int, @displayname varchar(255)
As
	declare @existingNodeId int, @h2g2id int

	DECLARE @ErrorCode INT
	BEGIN TRANSACTION
	SELECT @existingNodeId = NodeID, @h2g2id = h2g2ID FROM Hierarchy WITH(UPDLOCK) WHERE NodeID = @nodeid --and SiteID = @siteid

	/* Only update if the nodeid exists */
	IF (@existingNodeId IS NOT NULL)
	Begin
  	   UPDATE Hierarchy
		SET DisplayName = @displayname, LastUpdated = getDate()
		WHERE NodeID = @nodeid 
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'NodeID' = NULL
			RETURN @ErrorCode
		END
		UPDATE GuideEntries SET Subject = @displayname
			WHERE h2g2ID = @h2g2id
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