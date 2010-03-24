/*adds a comma separated list of articles to the hierarchy at a particular node*/

CREATE PROCEDURE addarticlestohierarchy @nodeid int, @h2g2ids VARCHAR(255), @userid int, @siteid INT
As

DECLARE @ErrorCode INT
DECLARE @Success INT
SET @success = 1
DECLARE @duplicate INT

DECLARE @entryid INT
DECLARE @h2g2id INT

BEGIN TRANSACTION

DECLARE entry_cursor CURSOR DYNAMIC FOR
SELECT entryid, h2g2id 
FROM GuideEntries g WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@h2g2ids) u ON u.element = g.h2g2id AND g.siteid = @siteid

OPEN entry_cursor
FETCH NEXT FROM entry_cursor INTO @entryid, @h2g2id
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @success = 1
	SET @duplicate = 0
	IF EXISTS ( SELECT entryid FROM HierarchyArticleMembers ha WHERE ha.NodeId = @nodeid AND ha.entryid = @entryid ) 
	BEGIN
		SET @success = 0
		SET @duplicate = 1
	END 

	IF @duplicate = 0
	BEGIN
		INSERT INTO hierarchyarticlemembers (NodeID,EntryID) 
		VALUES (@nodeid, @entryid)
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0) + 1  WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID = @entryid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		EXEC @ErrorCode = addtoeventqueueinternal 'ET_CATEGORYARTICLETAGGED', @nodeid, 'IT_NODE', @h2g2id, 'IT_H2G2', @userid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'AddArticleToHierarchy',
												  @siteid			= @siteid, 
												  @nodeid			= @nodeid, 
												  @entryid			= @entryid,
												  @userid			= @userid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	END

	--Use multiple resultsets - one resultset for each article. 
	SELECT 'Success' = @success, 
		'ObjectName' = g.Subject,
		'Duplicate' = @duplicate,
		'h2g2Id' = g.h2g2id,
		( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName
	FROM GuideEntries g
	WHERE g.entryid = @entryid


	FETCH NEXT FROM entry_cursor INTO @entryid, @h2g2id
END

CLOSE entry_cursor
DEALLOCATE entry_cursor

COMMIT TRANSACTION
RETURN 0

--DECLARE @rowcount INT
--DECLARE @entryids as table(entryid int)
--INSERT @entryids SELECT DISTINCT element/10 'entryid' FROM udf_splitvarchar(@h2g2ids) u
--				LEFT JOIN HierarchyArticleMembers ha ON ha.NodeId = @nodeid AND ha.EntryId = u.element/10
--				WHERE ha.EntryId IS NULL
				
--Check the Tag Limits.
--SELECT count(*) FROM GuideEntries g
--INNER JOIN entryids ON g.entryid = entryids.entryid
--INNER JOIN HierarchyArticleMembers ha ON ha.EntryId = g.entryid
--INNER JOIN Hierarhcy h ON h.NodeId = ha.NodeId
--LEFT JOIN ArticleTagLimits t ON t.NodeTypeId = h.NodeType AND t.ArticleType = g.ArticleType
--GROUP BY g.ArticleType
				

	--BEGIN TRANSACTION 

	--DECLARE @ErrorCode 	INT

	-- Add article to hierarchy node - test for duplicates
	--INSERT INTO hierarchyarticlemembers (NodeID,EntryID) 
	--SELECT @nodeid, entryid FROM @entryids 

	--SELECT @rowcount = @@ROWCOUNT
	--SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	-- Update the ArticleMembers count
	--UPDATE hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0) + @rowcount  WHERE nodeid=@nodeid
	--SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	-- Refresh the guide entry.  Forces the article cache to clear
	--UPDATE GuideEntries SET LastUpdated = getdate() 
	--WHERE EntryID IN ( SELECT entryid FROM @entryids )
	--SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	--COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	--EXEC addtoeventqueueinternal 'ET_CATEGORYARTICLETAGGED', @nodeid, 'IT_NODE', @h2g2id, 'IT_H2G2', @userid

	-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!	
	--DECLARE @SiteID INT

	--SELECT @SiteID = SiteID FROM dbo.GuideEntries WHERE EntryID = @EntryID

	--EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'AddArticleToHierarchy',
	--										  @siteid			= @SiteID, 
	--										  @nodeid			= @nodeid, 
	--										  @h2g2id			= @h2g2id,
	--										  @userid			= @userid

--SELECT 'Success' = @Success, 
--		'ObjectName' = g.Subject,
--		'Duplicate' = CASE WHEN updatedentrys.entryid IS NULL THEN 1 ELSE 0 END,
--		( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS DisplayName
--		FROM GuideEntries g
--		INNER JOIN ( SELECT DISTINCT element/10 'entryid' FROM udf_splitvarchar(@h2g2ids) ) requested ON requested.entryid = g.entryid
--		LEFT JOIN (  SELECT EntryId FROM @entryids ) AS updatedentrys ON updatedentrys.entryid = requested.entryid
	
--RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE entry_cursor
DEALLOCATE entry_cursor
SELECT 'Success' = 0
RETURN @ErrorCode
