CREATE PROCEDURE movearticlefromsourcetodestinationnode @ih2g2id int, @isourceid int, @idestinationid int
As

DECLARE @EntryID int
SET @EntryID = @ih2g2id/10

-- If it doesn't exist in source, or exists in destination, just return
IF NOT EXISTS (SELECT * FROM dbo.HierarchyArticleMembers WHERE EntryID = @EntryID and nodeid = @isourceid)
	OR EXISTS (SELECT * FROM dbo.HierarchyArticleMembers WHERE EntryID = @EntryID and nodeid = @idestinationid)
BEGIN
	SELECT 'Success'=0
	RETURN 0
END

DECLARE @ErrorCode INT
DECLARE @ObjectName varchar(255)
DECLARE @NodeName varchar(255)

SELECT @ObjectName = Subject FROM GuideEntries WHERE h2g2id = @ih2g2id
SELECT @NodeName = DisplayName FROM Hierarchy WHERE NodeID = @isourceid

BEGIN TRANSACTION

--Delete existing.
DELETE FROM HierarchyArticleMembers WHERE EntryID = @EntryID AND NodeID = @isourceid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Decrement count in source
UPDATE Hierarchy SET ArticleMembers = ArticleMembers-1 WHERE NodeID = @isourceid AND ArticleMembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

--Insert new tag	
INSERT INTO HierarchyArticleMembers(EntryID,NodeID) VALUES (@EntryID,@idestinationid)
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

-- Increment count in destination
UPDATE Hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0)+1 WHERE NodeID = @idestinationid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

--Update Last Updated, to force cached article data to expire
UPDATE GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @ih2g2id
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION

SELECT 'Success' = 1, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0, @ObjectName 'ObjectName', @NodeName 'NodeName'
RETURN @ErrorCode
