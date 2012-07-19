

CREATE PROCEDURE gettwitterscreennamefromtwitteruserid @twitteruserids nvarchar(max) 
AS

IF @twitteruserids <> ''
BEGIN
	SELECT LoginName AS TwitterScreenName FROM dbo.Users 
	WHERE UserID IN 
	(SELECT DnaUserID from dbo.SignInUserIDMapping sm 
		inner join dbo.udf_splitvarcharwithdelimiter(@twitteruserids, ',') ug ON sm.TwitterUserID = ug.element)	
END