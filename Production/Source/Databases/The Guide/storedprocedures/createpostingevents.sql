CREATE PROCEDURE createpostingevents	@userid int, @forumid int, @inreplyto int, @threadid int, @entryid int
AS

-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail the caller. If it works, it works!
EXEC addtoeventqueueinternal 'ET_FORUMEDITED', @ForumID, 'IT_FORUM', @threadid, 'IT_THREAD', @userid

-- update the eventqueue
IF (@inreplyto IS NULL)
BEGIN
	-- New thread created
	EXEC addtoeventqueueinternal 'ET_POSTNEWTHREAD', @forumid, 'IT_FORUM', @threadid, 'IT_THREAD', @userid
	EXEC addtoeventqueueinternal 'ET_POSTTOFORUM', @forumid, 'IT_FORUM', @entryid, 'IT_ENTRYID', @userid
END
ELSE
BEGIN
	-- Thread has reply
	EXEC addtoeventqueueinternal 'ET_POSTREPLIEDTO', @threadid, 'IT_THREAD', @inreplyto, 'IT_POST', @userid
	EXEC addtoeventqueueinternal 'ET_POSTTOFORUM', @forumid, 'IT_FORUM', @entryid, 'IT_ENTRYID', @userid
END
