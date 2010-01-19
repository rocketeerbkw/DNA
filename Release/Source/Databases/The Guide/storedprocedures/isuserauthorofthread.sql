CREATE PROCEDURE isuserauthorofthread @threadid INT, @userid INT 
AS

SELECT ThreadId FROM ThreadEntries WHERE ThreadId = @threadid AND PostIndex = 0 AND UserId = @userId


RETURN 0