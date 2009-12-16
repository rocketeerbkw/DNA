/* Expects a comma separated list of threads to add to a hierarchy node */
CREATE PROCEDURE addthreadstohierarchy @nodeid INT, @threadlist VARCHAR(255), @userid INT,  @siteid INT
AS

DECLARE @Success INT
DECLARE @Duplicate INT
DECLARE @ErrorCode INT

BEGIN TRANSACTION

DECLARE @forumid INT
DECLARE @threadid iNT
DECLARE thread_cursor CURSOR DYNAMIC FOR
SELECT threadid
FROM Threads t WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@threadlist) s ON s.element = t.threadid
INNER JOIN Forums f ON f.forumid = t.forumid and f.siteid = @siteid

OPEN thread_cursor
FETCH NEXT FROM thread_cursor INTO @threadid
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @success = 1
	SET @duplicate = 0
	IF EXISTS ( SELECT threadid FROM HierarchyThreadMembers ht WHERE ht.NodeId = @nodeid AND ht.threadid = @threadid ) 
	BEGIN
		SET @success = 0
		SET @duplicate = 1
	END 

	IF @duplicate = 0
	BEGIN
		
		INSERT INTO dbo.hierarchythreadmembers(NodeID, ThreadId) VALUES( @nodeid, @threadid)
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ThreadMembers = ISNULL(ThreadMembers,0)+1 WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		--Invalidate thread cache.									  
		Update Threads SET LastUpdated = getdate() WHERE threadid = @threadid
		
		-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
		EXEC addtoeventqueueinternal 'ET_CATEGORYTHREADTAGGED', @nodeid, 'IT_NODE', @threadid, 'IT_THREAD', @userid

		SELECT @forumid = forumid FROM threads WHERE threadid = @threadid
		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNoticeBoardPostToHierarchy', 
												  @siteid 		= @siteid, 
												  @nodeid		= @nodeid, 
												  @userid		= @userid, 
												  @threadid		= @threadid, 
												  @forumid		= @forumid

	END

	SELECT	'Success' = @Success,
			'Duplicate' = @Duplicate, 
			'ObjectName' = t.FirstSubject, 
			'ThreadId' = t.threadId,
			( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName 
			FROM [dbo].Threads t
			WHERE t.ThreadId = @threadId

	FETCH NEXT FROM thread_cursor INTO @threadid
END

COMMIT TRANSACTION

CLOSE thread_cursor
DEALLOCATE thread_cursor

RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE thread_cursor
DEALLOCATE thread_cursor
SELECT 'Success' = 0
RETURN @ErrorCode
