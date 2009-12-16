Create Procedure dosessions
As
DECLARE session CURSOR FOR
SELECT LogDate, UserID  FROM ActivityLog WHERE LogType = 'ONLN' AND LogDate > '1 Jan 2000' ORDER BY LogDate

OPEN session

declare @logdate datetime, @userid int

FETCH NEXT FROM session INTO @logdate, @userid

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC logusersession @userid, @logdate
	print @logdate
	FETCH NEXT FROM session INTO @logdate, @userid
END

CLOSE session
DEALLOCATE session

	return (0)