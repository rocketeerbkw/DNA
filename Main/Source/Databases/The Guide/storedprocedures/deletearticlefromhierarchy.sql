CREATE PROCEDURE deletearticlefromhierarchy @h2g2id int, @nodeid int
As

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

--Get details of Article about to be deleted.
DECLARE @Subject varchar(255)
DECLARE @NodeName varchar(255)
SELECT @Subject = g.Subject, @NodeName = h.DisplayName FROM [dbo].GuideEntries g
		INNER JOIN [dbo].HierarchyArticleMembers a ON g.EntryID=@EntryID
		INNER JOIN [dbo].Hierarchy h ON h.NodeID = a.NodeID
		WHERE a.NodeId=@nodeid

DECLARE @ErrorCode INT

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchyarticlemembers WHERE EntryID = @EntryID and nodeid = @nodeid
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0, 'Error' = @ErrorCode, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

UPDATE [dbo].hierarchy
	SET ArticleMembers = ArticleMembers - 1
	WHERE nodeid = @nodeid AND ArticleMembers > 0
IF (@@ERROR <> 0)
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0, 'Error' = @ErrorCode, 'ObjectName' = @Subject, 'NodeName' = @NodeName
	RETURN @ErrorCode
END

UPDATE [dbo].GuideEntries SET LastUpdated = getdate() WHERE EntryID = @EntryID
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
