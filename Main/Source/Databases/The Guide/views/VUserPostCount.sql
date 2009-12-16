CREATE VIEW VUserPostCount WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising user's post count per site. 
	*/

	SELECT	UserID, SiteID, COUNT_BIG(*) as 'Total'
	  FROM	dbo.ThreadEntries TE 
			INNER JOIN dbo.Forums F ON F.ForumID = TE.ForumID 
	 GROUP	BY te.UserID, f.SiteID
GO

CREATE UNIQUE CLUSTERED INDEX [IX_VUserPostCount] ON [dbo].[VUserPostCount] 
(
	[UserID], 
	[SiteID]
)
GO