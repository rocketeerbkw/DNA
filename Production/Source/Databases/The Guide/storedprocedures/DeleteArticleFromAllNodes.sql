/* Delete article from all hierarhcy nodes */
CREATE PROCEDURE deletearticlefromallnodes @h2g2id int, @siteid INT, @nodetypename VARCHAR(50) = null
As

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

--Need to get the relevant nodeids 
DECLARE @nodeids TABLE ( nodeid INT )
IF @nodetypename IS NOT NULL
BEGIN
	--Apply a node type filter - Only delete from a paticular type of node eg location node.
	INSERT INTO @nodeids
	SELECT h.nodeid FROM hierarchy h, hierarchyarticlemembers hm, hierarchynodetypes nt
	WHERE hm.EntryID = @EntryID AND hm.nodeid = h.nodeid AND h.type=nt.nodetype 
	AND nt.siteid=@siteid AND nt.description LIKE @nodetypename
END
ELSE
BEGIN
	-- Wish to delete article from all nodes.
	INSERT INTO @nodeids
	SELECT nodeid FROM HierarchyArticleMembers WHERE entryid = @EntryID
END

DECLARE @ErrorCode INT

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchyarticlemembers WHERE EntryID = @EntryID
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

UPDATE [dbo].hierarchy
SET ArticleMembers = ArticleMembers - 1
WHERE nodeid IN ( SELECT nodeid FROM @nodeids ) AND articlemembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

UPDATE [dbo].GuideEntries SET LastUpdated = getdate() WHERE EntryID = @EntryID
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION


SELECT 'Success' = 1, 'ObjectName' = ( SELECT subject FROM GuideEntries WHERE entryid = @EntryID ), 'NodeName' = h.displayname
FROM hierarchy h
INNER JOIN @nodeids n ON n.nodeid = h.nodeid
return(0)

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode
