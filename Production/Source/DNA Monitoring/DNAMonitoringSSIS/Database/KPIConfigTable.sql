USE [DNAMonitoring]
GO
--DROP TABLE dbo.[KPIConfig]
GO

CREATE TABLE [dbo].[KPIConfig](
	[AppName] [varchar](50) NOT NULL,
	[ServerName] [varchar](50) NOT NULL,
	[KPIName] [varchar](50) NOT NULL,
	[KPIType] [varchar](50) NOT NULL,
	[SubOid] int NOT NULL,
	[Url] [nvarchar](1000) NOT NULL,
	[yTitle] nvarchar(50) NOT NULL,
	[minThreshD] int NULL,
	[maxThreshD] int NULL,
	[minThreshI] int NULL,
	[maxThreshI] int NULL,
	[minThreshW] int NULL,
	[maxThreshW] int NULL,
	[minThreshE] int NULL,
	[maxThreshE] int NULL,
	[minThreshC] int NULL,
	[maxThreshC] int NULL,
	CONSTRAINT PK_KPIConfig PRIMARY KEY CLUSTERED (AppName,ServerName,KPIName),
	CONSTRAINT UIX_KPIConfig_AppNameSubOid UNIQUE (AppName,SubOid)
) ON [PRIMARY]
GO

