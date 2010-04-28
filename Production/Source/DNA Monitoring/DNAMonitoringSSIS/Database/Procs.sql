IF OBJECT_ID('AddAppOid') IS NOT NULL 
	DROP PROC AddAppOid
GO
CREATE PROC AddAppOid @AppName varchar(50), @AppOid varchar(100)
AS
	INSERT INTO dbo.AppOids VALUES(@AppName, @AppOid);
GO

IF OBJECT_ID('AddKPIConfig') IS NOT NULL 
	DROP PROC AddKPIConfig
GO
CREATE PROC AddKPIConfig @AppName varchar(50), @ServerName varchar(50), @KPIName varchar(50), @KPIType varchar(50), @Url nvarchar(1000), @yTitle nvarchar(50)
AS
	-- Can't carry on unless an AppOid has been registered
	IF EXISTS(SELECT * FROM dbo.AppOids ao WHERE ao.AppName = @AppName)
	BEGIN
		-- The suboid has to be unique per AppName
		DECLARE @suboid int
		SELECT @suboid = MAX(Suboid)+1 
			FROM dbo.KPIConfig kc
			WHERE kc.AppName = @AppName;
		IF @suboid IS NULL SET @suboid = 1
		
		INSERT INTO dbo.KPIConfig (AppName, ServerName, KPIName, KPIType, SubOid, Url, yTitle)
				VALUES(@AppName,@ServerName, @KPIName, @KPIType, @suboid, @Url, @yTitle)
	END
	ELSE
	BEGIN
		RAISERROR ('There is no AppOid registered that matches the AppName passed in',16,1);
	END
GO
	
IF OBJECT_ID('ChangeKPIThresholds') IS NOT NULL 
	DROP PROC ChangeKPIThresholds
GO
CREATE PROC ChangeKPIThresholds @AppName varchar(50), @ServerName varchar(50), @KPIName varchar(50), @class varchar(20), @min int, @max int
AS
	IF @class = 'debug'
		UPDATE KPIConfig SET minThreshD=@min, maxThreshD=@max
			WHERE AppName = @AppName AND (ServerName = @ServerName OR @ServerName IS NULL) AND KPIName = @KPIName

	IF @class = 'info'
		UPDATE KPIConfig SET minThreshI=@min, maxThreshI=@max
			WHERE AppName = @AppName AND (ServerName = @ServerName OR @ServerName IS NULL) AND KPIName = @KPIName

	IF @class = 'warning'
		UPDATE KPIConfig SET minThreshW=@min, maxThreshW=@max
			WHERE AppName = @AppName AND (ServerName = @ServerName OR @ServerName IS NULL) AND KPIName = @KPIName

	IF @class = 'error'
		UPDATE KPIConfig SET minThreshE=@min, maxThreshE=@max
			WHERE AppName = @AppName AND (ServerName = @ServerName OR @ServerName IS NULL) AND KPIName = @KPIName

	IF @class = 'critical'
		UPDATE KPIConfig SET minThreshC=@min, maxThreshC=@max
			WHERE AppName = @AppName AND (ServerName = @ServerName OR @ServerName IS NULL) AND KPIName = @KPIName
GO			

IF OBJECT_ID('GetLatestKPIs') IS NOT NULL 
	DROP PROC GetLatestKPIs
GO
CREATE PROC GetLatestKPIs
AS
	-- Move the old KPIs to the KPIsHistory table
	;WITH orderedKPIs AS
	(
		SELECT ROW_NUMBER() OVER(PARTITION BY AppName,ServerName,KPIName ORDER BY dt DESC) n, *
		from dbo.KPIs k
	)
	DELETE FROM orderedKPIs
	OUTPUT DELETED.[dt] [smalldatetime],
		DELETED.[AppName],
		DELETED.[ServerName],
		DELETED.[KPIName],
		DELETED.[KPIValue]
	INTO KPIsHistory
	WHERE n>1

	-- We can now select all entries from the KPIs table as only the latest are there
	SELECT
		k.dt,
		ao.AppOid,
		ao.AppOid+'.'+CAST(kc.SubOid AS VARCHAR) AS Oid,
		k.AppName,
		k.ServerName,
		k.KPIName,
		k.KPIValue,
		kc.KPIType,
		kc.Url,
		kc.yTitle,
		kc.minThreshD,
		kc.maxThreshD,
		kc.minThreshI,
		kc.maxThreshI,
		kc.minThreshW,
		kc.maxThreshW,
		kc.minThreshE,
		kc.maxThreshE,
		kc.minThreshC,
		kc.maxThreshC
	FROM dbo.KPIs k
	INNER JOIN dbo.KPIConfig kc ON kc.AppName=k.AppName AND kc.ServerName=k.ServerName AND kc.KPIName=k.KPIName
	INNER JOIN dbo.AppOids ao ON ao.AppName = k.AppName
	ORDER BY ao.AppOid,Oid
GO

