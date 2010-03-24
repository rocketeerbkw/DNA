CREATE PROCEDURE getlinkteamid @linkid INT 
AS 
BEGIN
	SELECT TeamID 
	FROM dbo.links 
	WHERE linkid = @linkid
END