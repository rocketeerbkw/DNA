USE [DNAMonitoring]
GO

DROP TABLE dbo.AppOids
GO

/****** Object:  Table [dbo].[KPIConfig]    Script Date: 03/08/2010 14:12:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE dbo.AppOids
(
	AppName varchar(50) NOT NULL CONSTRAINT PK_AppOids PRIMARY KEY CLUSTERED,
	AppOid varchar(100) NOT NULL CONSTRAINT UIX_AppOids_AppOid UNIQUE
)  ON [PRIMARY]
GO
