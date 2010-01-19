CREATE PROCEDURE logregistrationattempt @userid int, @email varchar(255), @ipaddress varchar(255)
As
INSERT INTO ActivityLog (IPaddress, UserID, LogType, Details1, LogDate)
VALUES(@ipaddress, @userid, 'REGI', @email, getdate())
