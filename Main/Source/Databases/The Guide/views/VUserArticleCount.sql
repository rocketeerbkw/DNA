CREATE VIEW VUserArticleCount WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising user's article count per site. 
	*/

	SELECT ge.Editor as 'UserID', ge.SiteID, COUNT_BIG(*) as 'Total'
	  FROM dbo.GuideEntries ge
	 WHERE ge.Type <> 3001
	 GROUP BY ge.Editor, ge.SiteID
GO

CREATE UNIQUE CLUSTERED INDEX [IX_VUserArticleCount] ON [dbo].[VUserArticleCount] 
(
	[UserID], 
	[SiteID]
)
GO
