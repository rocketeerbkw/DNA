CREATE VIEW VGuideEntryText_memoryshare WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising GuideEntry id, subject and text for full-text searching. 
		The name of the view maps onto the Site's URLName so decisions about which catalogue to query can be done programatically. 
	*/

	SELECT	ge.EntryID,
			ge.Subject,
			ge.text
	  FROM	dbo.Sites s
			INNER JOIN dbo.GuideEntries ge ON s.SiteID = ge.SiteID
	 WHERE	s.URLName = 'memoryshare'

GO

CREATE UNIQUE CLUSTERED INDEX [IX_VGuideEntryText_memoryshare] ON [dbo].[VGuideEntryText_memoryshare] 
(
	[EntryID]
)

GO