CREATE PROCEDURE logusercancelled @userid int, @ipaddress varchar(255), @usercancelled int
As
INSERT INTO ActivityLog (UserID, IPAddress, LogDate, LogType, Details1)
VALUES(@userid, @IPaddress, getdate(), 'CANC', CAST(@usercancelled AS varchar(255)))