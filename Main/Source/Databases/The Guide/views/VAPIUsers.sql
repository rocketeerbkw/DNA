/****** Object:  View [dbo].[VAPIUsers]    Script Date: 02/05/2009 16:56:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VAPIUsers]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW VAPIUsers
AS
SELECT     TOP (100) PERCENT dbo.SignInUserIDMapping.SSOUserID, dbo.SignInUserIDMapping.IdentityUserID, dbo.SignInUserIDMapping.DnaUserID, 
                      dbo.Users.UserID, dbo.Users.UserName, dbo.Users.LastName, dbo.Users.FirstNames, dbo.Users.DateJoined
FROM         dbo.Users INNER JOIN
                      dbo.SignInUserIDMapping ON dbo.Users.UserID = dbo.SignInUserIDMapping.DnaUserID
ORDER BY dbo.Users.UserID DESC'

GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VAPIUsers]'))
EXEC dbo.sp_executesql @statement = N'
ALTER VIEW VAPIUsers
AS
SELECT     TOP (100) PERCENT dbo.SignInUserIDMapping.SSOUserID, dbo.SignInUserIDMapping.IdentityUserID, dbo.SignInUserIDMapping.DnaUserID, 
                      dbo.Users.UserName, dbo.Users.LastName, dbo.Users.FirstNames, dbo.Users.DateJoined
FROM         dbo.Users INNER JOIN
                      dbo.SignInUserIDMapping ON dbo.Users.UserID = dbo.SignInUserIDMapping.DnaUserID
ORDER BY dbo.SignInUserIDMapping.DnaUserID DESC'
GO
