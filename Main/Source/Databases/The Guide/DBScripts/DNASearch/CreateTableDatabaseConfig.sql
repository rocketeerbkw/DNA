USE [DNASearch]
GO
/****** Object:  Table [dbo].[DatabaseConfig]    Script Date: 10/04/2010 12:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseConfig](
	[server] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT [PK_DatabaseConfig] PRIMARY KEY ([server],[database])

) ON [PRIMARY]
