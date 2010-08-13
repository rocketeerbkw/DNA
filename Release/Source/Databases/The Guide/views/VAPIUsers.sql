CREATE VIEW VAPIUsers
AS
SELECT dbo.SignInUserIDMapping.SSOUserID, dbo.SignInUserIDMapping.IdentityUserID, dbo.SignInUserIDMapping.DnaUserID, 
                      dbo.Users.UserName, dbo.Users.LoginName, dbo.Users.LastName, dbo.Users.FirstNames, dbo.Users.DateJoined
FROM         
	dbo.Users INNER JOIN dbo.SignInUserIDMapping ON dbo.Users.UserID = dbo.SignInUserIDMapping.DnaUserID
