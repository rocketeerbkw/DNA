/*
Deployment script for DNA_Stats
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DNA_Stats"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\DATA\"

GO
USE [master]

GO
:on error exit
GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [PrimaryFileName], FILENAME = '$(DefaultDataPath)$(DatabaseName).mdf')
    LOG ON (NAME = [PrimaryLogFileName], FILENAME = '$(DefaultDataPath)$(DatabaseName)_log.ldf') COLLATE SQL_Latin1_General_CP1_CS_AS
GO
EXECUTE sp_dbcmptlevel [$(DatabaseName)], 90;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC ON,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)]

GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script	
 Use SQLCMD syntax to include a file into the pre-deployment script			
 Example:      :r .\filename.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/




GO
PRINT N'Creating [dbo].[http_method]...';


GO
CREATE TABLE [dbo].[http_method] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_http_method...';


GO
ALTER TABLE [dbo].[http_method]
    ADD CONSTRAINT [PK_http_method] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[http_status]...';


GO
CREATE TABLE [dbo].[http_status] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_http_status...';


GO
ALTER TABLE [dbo].[http_status]
    ADD CONSTRAINT [PK_http_status] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[impressions]...';


GO
CREATE TABLE [dbo].[impressions] (
    [date]         DATETIME NOT NULL,
    [http_method]  INT      NOT NULL,
    [http_status]  INT      NOT NULL,
    [machine_name] INT      NOT NULL,
    [site]         INT      NOT NULL,
    [url]          INT      NOT NULL,
    [count]        INT      NOT NULL,
    [min]          INT      NOT NULL,
    [max]          INT      NOT NULL,
    [avg]          INT      NOT NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_impressions...';


GO
ALTER TABLE [dbo].[impressions]
    ADD CONSTRAINT [PK_impressions] PRIMARY KEY CLUSTERED ([date] ASC, [http_method] ASC, [http_status] ASC, [machine_name] ASC, [site] ASC, [url] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[machine_name]...';


GO
CREATE TABLE [dbo].[machine_name] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_machine_name...';


GO
ALTER TABLE [dbo].[machine_name]
    ADD CONSTRAINT [PK_machine_name] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[perf_counter]...';


GO
CREATE TABLE [dbo].[perf_counter] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_perf_counter...';


GO
ALTER TABLE [dbo].[perf_counter]
    ADD CONSTRAINT [PK_perf_counter] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[perf_instance]...';


GO
CREATE TABLE [dbo].[perf_instance] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_perf_instance...';


GO
ALTER TABLE [dbo].[perf_instance]
    ADD CONSTRAINT [PK_perf_instance] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[perf_type]...';


GO
CREATE TABLE [dbo].[perf_type] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (50)  COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_perf_type...';


GO
ALTER TABLE [dbo].[perf_type]
    ADD CONSTRAINT [PK_perf_type] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[perfMon]...';


GO
CREATE TABLE [dbo].[perfMon] (
    [datetime]      DATETIME NOT NULL,
    [machine_name]  INT      NOT NULL,
    [perf_type]     INT      NOT NULL,
    [perf_instance] INT      NOT NULL,
    [perf_counter]  INT      NOT NULL,
    [value]         REAL     NOT NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_perfMon...';


GO
ALTER TABLE [dbo].[perfMon]
    ADD CONSTRAINT [PK_perfMon] PRIMARY KEY CLUSTERED ([datetime] ASC, [machine_name] ASC, [perf_type] ASC, [perf_instance] ASC, [perf_counter] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[site]...';


GO
CREATE TABLE [dbo].[site] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (100) COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_site...';


GO
ALTER TABLE [dbo].[site]
    ADD CONSTRAINT [PK_site] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[url]...';


GO
CREATE TABLE [dbo].[url] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [value]       VARCHAR (1000) COLLATE Latin1_General_CI_AS NOT NULL,
    [description] VARCHAR (255)  COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY];


GO
PRINT N'Creating PK_url...';


GO
ALTER TABLE [dbo].[url]
    ADD CONSTRAINT [PK_url] PRIMARY KEY CLUSTERED ([id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


GO
PRINT N'Creating FK_impressions_http_method...';


GO
ALTER TABLE [dbo].[impressions] WITH NOCHECK
    ADD CONSTRAINT [FK_impressions_http_method] FOREIGN KEY ([http_method]) REFERENCES [dbo].[http_method] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_impressions_http_status...';


GO
ALTER TABLE [dbo].[impressions] WITH NOCHECK
    ADD CONSTRAINT [FK_impressions_http_status] FOREIGN KEY ([http_status]) REFERENCES [dbo].[http_status] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_impressions_machine_name...';


GO
ALTER TABLE [dbo].[impressions] WITH NOCHECK
    ADD CONSTRAINT [FK_impressions_machine_name] FOREIGN KEY ([machine_name]) REFERENCES [dbo].[machine_name] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_impressions_site...';


GO
ALTER TABLE [dbo].[impressions] WITH NOCHECK
    ADD CONSTRAINT [FK_impressions_site] FOREIGN KEY ([site]) REFERENCES [dbo].[site] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_impressions_url...';


GO
ALTER TABLE [dbo].[impressions] WITH NOCHECK
    ADD CONSTRAINT [FK_impressions_url] FOREIGN KEY ([url]) REFERENCES [dbo].[url] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_perfMon_machine_name...';


GO
ALTER TABLE [dbo].[perfMon] WITH NOCHECK
    ADD CONSTRAINT [FK_perfMon_machine_name] FOREIGN KEY ([machine_name]) REFERENCES [dbo].[machine_name] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_perfMon_perf_counter...';


GO
ALTER TABLE [dbo].[perfMon] WITH NOCHECK
    ADD CONSTRAINT [FK_perfMon_perf_counter] FOREIGN KEY ([perf_counter]) REFERENCES [dbo].[perf_counter] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_perfMon_perf_instance...';


GO
ALTER TABLE [dbo].[perfMon] WITH NOCHECK
    ADD CONSTRAINT [FK_perfMon_perf_instance] FOREIGN KEY ([perf_instance]) REFERENCES [dbo].[perf_instance] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_perfMon_perf_type...';


GO
ALTER TABLE [dbo].[perfMon] WITH NOCHECK
    ADD CONSTRAINT [FK_perfMon_perf_type] FOREIGN KEY ([perf_type]) REFERENCES [dbo].[perf_type] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating [dbo].[http_methodget]...';


GO
CREATE PROCEDURE [dbo].[http_methodget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	http_method
	where value=@value

	if @id is null
	BEGIN
		insert into http_method
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[http_statusget]...';


GO
CREATE PROCEDURE [dbo].[http_statusget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	http_status
	where value=@value

	if @id is null
	BEGIN
		insert into http_status
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[machine_nameget]...';


GO
CREATE PROCEDURE [dbo].[machine_nameget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	machine_name
	where value=@value

	if @id is null
	BEGIN
		insert into machine_name
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[perf_counterget]...';


GO
CREATE PROCEDURE [dbo].[perf_counterget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_counter
	where value=@value

	if @id is null
	BEGIN
		insert into perf_counter
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[perf_instanceget]...';


GO
CREATE PROCEDURE [dbo].[perf_instanceget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_instance
	where value=@value

	if @id is null
	BEGIN
		insert into perf_instance
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[perf_typeget]...';


GO
CREATE PROCEDURE [dbo].[perf_typeget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_type
	where value=@value

	if @id is null
	BEGIN
		insert into perf_type
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[perfMonWrite]...';


GO
CREATE PROCEDURE [dbo].[perfMonWrite] @date datetime, @machine_name varchar(50), @perf_type varchar(50), 
	@perf_instance varchar(50), @perf_counter varchar(50), @value real
AS
BEGIN
	SET NOCOUNT ON;
	
	--declare id variables
	declare @machine_nameid int
	declare @perf_typeid int
	declare @perf_instanceid int
	declare @perf_counterid int

	--call sps to return ID values
	exec perf_typeget @perf_type, @perf_typeid output
	exec machine_nameget @machine_name, @machine_nameid output
	exec perf_instanceget @perf_instance, @perf_instanceid output
	exec perf_counterget @perf_counter, @perf_counterid output
	
	
	-- do update
	update perfMon
	set
	value = @value
	where
	datetime = @date and perf_type = @perf_typeid and machine_name = @machine_nameid
	and perf_instance = @perf_instanceid and perf_counter = @perf_counterid

	--check if updated - otherwise insert
	if @@rowcount = 0
	BEGIN
		insert into perfMon	
		(datetime,perf_instance,perf_type,machine_name,perf_counter, value)
		values
		(@date,@perf_instanceid,@perf_typeid, @machine_nameid,@perf_counterid,@value)
	END
END
GO
PRINT N'Creating [dbo].[siteget]...';


GO
CREATE PROCEDURE [dbo].[siteget] @value varchar(50)='', @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	site
	where value=@value

	if @id is null
	BEGIN
		insert into site
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[urlget]...';


GO
CREATE PROCEDURE [dbo].[urlget] @value varchar(1000), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	url
	where value=@value

	if @id is null
	BEGIN
		insert into url
		(value)
		values
		(@value)

		set @id = @@identity
    END
END
GO
PRINT N'Creating [dbo].[impressionswrite]...';


GO
CREATE PROCEDURE [dbo].[impressionswrite] @date datetime, @machine_name varchar(50), @http_method varchar(50), 
	@http_status varchar(50), @url varchar(100), @site varchar(50), @count int, @min int, @max int, @avg int
AS
BEGIN
	SET NOCOUNT ON;
	
	--declare id variables
	declare @machine_nameid int
	declare @http_methodid int
	declare @http_statusid int
	declare @urlid int
	declare @siteid int

	--call sps to return ID values
	exec http_methodget @http_method, @http_methodid output
	exec machine_nameget @machine_name, @machine_nameid output
	exec http_statusget @http_status, @http_statusid output
	exec urlget @url, @urlid output
	exec siteget @site, @siteid output
	
	-- do update
	update impressions
	set
	count = @count, min=@min, max=@max, avg=@avg
	where
	date = @date and http_method = @http_methodid and machine_name = @machine_nameid
	and http_status = @http_statusid and url = @urlid and site = @siteid

	--check if updated - otherwise insert
	if @@rowcount = 0
	BEGIN
		insert into impressions	
		(date,http_method,machine_name,http_status,url,site, count, min, max, avg)
		values
		(@date,@http_methodid,@machine_nameid,@http_statusid,@urlid,@siteid,@count,@min,@max,@avg)
	END
END
GO
-- Refactoring step to update target server with deployed transaction logs
CREATE TABLE  [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
GO
sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script		
 Use SQLCMD syntax to include a file into the post-deployment script			
 Example:      :r .\filename.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/





GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[impressions] WITH CHECK CHECK CONSTRAINT [FK_impressions_http_method];

ALTER TABLE [dbo].[impressions] WITH CHECK CHECK CONSTRAINT [FK_impressions_http_status];

ALTER TABLE [dbo].[impressions] WITH CHECK CHECK CONSTRAINT [FK_impressions_machine_name];

ALTER TABLE [dbo].[impressions] WITH CHECK CHECK CONSTRAINT [FK_impressions_site];

ALTER TABLE [dbo].[impressions] WITH CHECK CHECK CONSTRAINT [FK_impressions_url];

ALTER TABLE [dbo].[perfMon] WITH CHECK CHECK CONSTRAINT [FK_perfMon_machine_name];

ALTER TABLE [dbo].[perfMon] WITH CHECK CHECK CONSTRAINT [FK_perfMon_perf_counter];

ALTER TABLE [dbo].[perfMon] WITH CHECK CHECK CONSTRAINT [FK_perfMon_perf_instance];

ALTER TABLE [dbo].[perfMon] WITH CHECK CHECK CONSTRAINT [FK_perfMon_perf_type];


GO
