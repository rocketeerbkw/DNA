CREATE PROCEDURE addthreadtohierarchy @nodeid INT, @threadid INT, @userid int
AS

DECLARE @Duplicate INT
SET @Duplicate = 0

DECLARE @Success INT
SET @Success = 1

DECLARE @ErrorCode INT


IF NOT EXISTS (SELECT * from dbo.hierarchythreadmembers where nodeid=@nodeid AND threadid=@threadid)
BEGIN
	BEGIN TRANSACTION
		
	INSERT INTO dbo.hierarchythreadmembers(NodeID, ThreadId) VALUES( @nodeid, @threadid)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE hierarchy SET ThreadMembers = ISNULL(ThreadMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	COMMIT TRANSACTION
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYTHREADTAGGED', @nodeid, 'IT_NODE', @threadid, 'IT_THREAD', @userid

	-- update content signif.We don't want zeitgeist to fail this procedure. If it works, it works!
	DECLARE @siteid int, @forumid int

	SELECT @siteid = t.SiteID, @forumid = t.ForumID FROM Threads t
			WHERE t.ThreadID = @threadid
	
	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNoticeBoardPostToHierarchy', 
											  @siteid 		= @siteid, 
											  @nodeid		= @nodeid, 
											  @userid		= @userid, 
											  @threadid		= @threadid, 
											  @forumid		= @forumid
		
	--Invalidate thread cache.									  
	Update Threads SET LastUpdated = getdate() WHERE threadid = @threadid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

Select 'Success' = @Success,'Duplicate' = @Duplicate, 'ObjectName' = t.FirstSubject, 'NodeName' = h.DisplayName 
			FROM [dbo].Threads t
			INNER JOIN Hierarchy h ON h.NodeID = @nodeid
			WHERE t.ThreadId = @threadId

return(0)

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode
