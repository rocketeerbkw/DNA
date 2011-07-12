CREATE PROCEDURE logregistrationattempt @userid int, @email varchar(255), @ipaddress varchar(255)
As
RAISERROR('logregistrationattempt DEPRECATED',16,1)
/*
-- Deprecated - no data in this table, so not used in current system

INSERT INTO ActivityLog (IPaddress, UserID, LogType, Details1, LogDate)
VALUES(@ipaddress, @userid, 'REGI', @email, getdate())
*/
