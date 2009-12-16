CREATE PROCEDURE getuploadsforteam  @teamid int
AS
	SELECT * FROM Uploads WHERE TeamID=@teamid
