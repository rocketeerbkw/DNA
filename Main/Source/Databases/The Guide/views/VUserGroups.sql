SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VUserGroups]'))
	EXEC dbo.sp_executesql @statement = N'DROP VIEW [dbo].[VUserGroups]'
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VUserGroups]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW VUserGroups
AS
SELECT     dbo.GroupMembers.UserID, dbo.GroupMembers.GroupID, dbo.Groups.Name, dbo.GroupMembers.SiteID
FROM         dbo.GroupMembers INNER JOIN
                      dbo.Groups ON dbo.GroupMembers.GroupID = dbo.Groups.GroupID

'
