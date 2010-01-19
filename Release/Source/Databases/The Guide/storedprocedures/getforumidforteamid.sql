CREATE PROCEDURE getforumidforteamid @teamid INT 
AS
BEGIN 
	SELECT ForumID 
	FROM dbo.teams WITH (NOLOCK)
	WHERE teamid =@teamid 
END