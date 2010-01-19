CREATE Procedure updatehierarchydescription @nodeid int, @description varchar(1023), @siteid int
As
	declare @existingNodeId int

	SELECT @existingNodeId = NodeID FROM Hierarchy WHERE NodeID = @nodeid --and SiteID = @siteid

	/* Only update if the nodeid exists */
	IF (@existingNodeId IS NOT NULL)
	Begin
  	   UPDATE Hierarchy
		SET Description = @description, LastUpdated = getDate()
		WHERE NodeID = @nodeid --and SiteID = @siteid

	   SELECT 'NodeID' = @nodeid
	 END
 	ELSE
	 BEGIN
	   SELECT 'NodeID' = NULL
  	 END
	 return(0)