CREATE PROCEDURE getuploadsforuser  @userid int
AS
	SELECT * FROM Uploads WHERE UserID=@userid
