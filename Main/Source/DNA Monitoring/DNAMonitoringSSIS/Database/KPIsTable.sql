USE [DNAMonitoring]
GO
--DROP TABLE [KPIs]
--DROP TABLE [KPIsHistory]
GO

CREATE TABLE [dbo].[KPIs](
	[dt] [smalldatetime] NOT NULL,
	[AppName] [varchar](50) NOT NULL,
	[ServerName] [varchar](50) NOT NULL,
	[KPIName] [varchar](50) NOT NULL,
	[KPIValue] int NOT NULL,
	[TTL] int NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[KPIsHistory](
	[dt] [smalldatetime] NOT NULL,
	[AppName] [varchar](50) NOT NULL,
	[ServerName] [varchar](50) NOT NULL,
	[KPIName] [varchar](50) NOT NULL,
	[KPIValue] int NOT NULL,
	[TTL] int NOT NULL
) ON [PRIMARY]

CREATE CLUSTERED INDEX CIX_KPIs_dt ON dbo.KPIs(dt)
CREATE CLUSTERED INDEX CIX_KPIsHistory_dt ON dbo.KPIsHistory(dt)
