CREATE PROCEDURE flushtempuserlist @uid uniqueidentifier
as
DELETE from TempUserList
WHERE UID = @uid
