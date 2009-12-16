CREATE PROCEDURE getallnodesthatuserbelongsto @iuserid INT
AS
BEGIN
	--There are 2 mechanisms here.
	-- A notice board post is attached to a node via the HierarchyThreadMembers table. 

	--Get Node that Notice Board post has been attached to.
	SELECT h.NodeID, h.Type, h.DisplayName, h.SiteID, h.NodeMembers 
	FROM [dbo].hierarchy AS h
	INNER JOIN [dbo].hierarchyusermembers u ON u.NodeID = h.NodeID
	WHERE u.UserId = @iuserid

	DECLARE @ErrorCode INT
	IF ( @@ERROR <> 0 ) 
	BEGIN
		SET @ErrorCode = @@ERROR
		EXECUTE Error ErrorCode
		RETURN @ErrorCode
	END

	RETURN 0
END