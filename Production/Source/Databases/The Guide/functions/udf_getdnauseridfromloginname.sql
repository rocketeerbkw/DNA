CREATE FUNCTION udf_getdnauseridfromloginname (@loginname VARCHAR(255))
RETURNS INT
AS
BEGIN
	DECLARE @UserID AS INT
	SELECT TOP 1 @UserID = UserID FROM Users WHERE LoginName=@loginname ORDER BY UserID DESC
	
	RETURN @UserID
END