/* Delete Thread from all hierarchy nodes */
CREATE PROCEDURE deletethreadfromallnodes @threadid int
As

DECLARE @ErrorCode INT
DECLARE @Success INT

DECLARE @nodeids AS TABLE ( nodeid INT )
INSERT INTO @nodeids 
SELECT nodeid FROM hierarchythreadmembers WHERE threadid = @threadid

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchythreadmembers	WHERE threadID = @threadid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


UPDATE [dbo].Hierarchy
	SET ThreadMembers = threadmembers - 1
	WHERE nodeid IN ( SELECT nodeid FROM @nodeids ) AND threadmembers > 0 
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


--Invalidate Thread Cache.
UPDATE Threads SET LastUpdated = getdate() WHERE threadid = @threadid
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION

SELECT 'Success' = 1, 'ObjectName' = (SELECT firstsubject FROM threads WHERE threadid = @threadid), 'NodeName' = h.displayname
FROM Hierarchy h
INNER JOIN @nodeids n ON n.nodeid = h.nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode