CREATE PROCEDURE deleteclubfromhierarchy @clubid int, @nodeid int
As

--Get Details of club for deletion.
DECLARE @h2g2id int
DECLARE @Subject varchar(255)
DECLARE @NodeName varchar(255)
SELECT @Subject = g.Subject, @h2g2id = c.h2g2id, @NodeName = a.DisplayName FROM [dbo].GuideEntries g
	INNER JOIN [dbo].Hierarchy a ON @nodeid = a.NodeID
	INNER JOIN [dbo].HierarchyClubMembers h ON h.NodeId=@nodeid
	INNER JOIN [dbo].Clubs c ON c.ClubID = @clubid
	WHERE g.h2g2ID = c.h2g2ID

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM [dbo].hierarchyclubmembers WHERE ClubID = @clubid and nodeid = @nodeid
IF ( @@ERROR <> 0 OR @@ROWCOUNT = 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0, 'Error' = @ErrorCode, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

UPDATE [dbo].hierarchy
	SET ClubMembers = ((SELECT ClubMembers From [dbo].hierarchy h WITH(UPDLOCK) WHERE h.nodeid = @nodeid) - 1) 
	WHERE nodeid = @nodeid AND ClubMembers > 0
IF (@@ERROR <> 0)
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0, 'Error' = @ErrorCode, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

UPDATE [dbo].GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @h2g2id
IF (@@ERROR <> 0)
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0, 'Error' = @ErrorCode, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

COMMIT TRANSACTION
SELECT 'Success' = 1, 'ObjectName' = @Subject, 'NodeName' = @NodeName

return(0)