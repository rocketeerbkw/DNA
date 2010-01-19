CREATE VIEW VGuideEntryText_collective WITH SCHEMABINDING
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
	 WHERE	s.URLName = 'collective'

GO

CREATE UNIQUE CLUSTERED INDEX [IX_VGuideEntryText_collective] ON [dbo].[VGuideEntryText_collective] 
(
	[EntryID]
)

GO