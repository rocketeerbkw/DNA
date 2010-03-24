/*adds an article to the hierarchy at a particular node*/

CREATE PROCEDURE addarticletohierarchy @nodeid int, @h2g2id int, @userid int
As

DECLARE @Success INT
SET @Success = 1
DECLARE @Duplicate INT
SET @Duplicate = 0

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

IF NOT EXISTS (SELECT * from hierarchyarticlemembers where nodeid=@nodeid AND EntryID=@EntryID)
BEGIN
	BEGIN TRANSACTION 

	DECLARE @ErrorCode 	INT

	-- Add article to hierarchy node
	INSERT INTO hierarchyarticlemembers (NodeID,EntryID) VALUES(@nodeid,@EntryID)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	-- Update the ArticleMembers count
	UPDATE hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	-- Refresh the guide entry.  Forces the article cache to clear
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID = @EntryID
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYARTICLETAGGED', @nodeid, 'IT_NODE', @h2g2id, 'IT_H2G2', @userid

	-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!	
	DECLARE @SiteID INT

	SELECT @SiteID = SiteID FROM dbo.GuideEntries WHERE EntryID = @EntryID

	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'AddArticleToHierarchy',
											  @siteid			= @SiteID, 
											  @nodeid			= @nodeid, 
											  @entryid			= @EntryID,
											  @userid			= @userid
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

SELECT 'Success' = @Success,'Duplicate' = @Duplicate, 'ObjectName' = g.Subject, 'NodeName' = h.DisplayName 
			FROM GuideEntries g, Hierarchy h
			WHERE g.EntryID=@EntryID AND h.nodeid=@nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode
