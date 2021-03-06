
CREATE TABLE [dbo].[SearchThreadEntries](
	[ThreadEntryID] [int] NOT NULL,
	[SiteID] [int] NULL,
	[subject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatePosted] [datetime] NOT NULL,
	[ForumID] [int] NOT NULL,
CONSTRAINT [PK_SearchThreadEntries] PRIMARY KEY (
		[ThreadEntryID] ASC
	)
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_SearchThreadEntries_DatePosted 
	ON dbo.SearchThreadEntries(DatePosted)
	INCLUDE (SiteId)
GO
CREATE NONCLUSTERED INDEX IX_SearchThreadEntries_SiteId
	ON dbo.SearchThreadEntries(SiteId)
GO
GRANT SELECT ON [dbo].[SearchThreadEntries] TO [ripleyrole]
