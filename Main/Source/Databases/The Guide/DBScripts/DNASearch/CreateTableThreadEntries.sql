USE [DNASearch]
GO
/****** Object:  Table [dbo].[ThreadEntries]    Script Date: 10/04/2010 12:46:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GRANT SELECT ON [dbo].[SearchThreadEntries] TO [ripleyrole]
