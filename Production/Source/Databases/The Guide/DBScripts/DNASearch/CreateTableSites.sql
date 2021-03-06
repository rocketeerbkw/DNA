USE [DNASearch]
GO
/****** Object:  Table [dbo].[Sites]    Script Date: 10/04/2010 12:45:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchSites](
	[SiteID] [int] NOT NULL,
	[URLName] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MonthsToRetain] [int] NOT NULL,
	CONSTRAINT [PK_SearchSites] PRIMARY KEY ([SiteID],[URLName])

) ON [PRIMARY]

