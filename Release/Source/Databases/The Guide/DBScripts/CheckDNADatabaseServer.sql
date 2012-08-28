USE [Performance]
GO
/****** Object:  StoredProcedure [dbo].[CheckDNADatabaseServer]    Script Date: 08/06/2012 11:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CheckDNADatabaseServer]
AS

--------------------------------------
-- Configuration Variables
DECLARE @sendTo varchar(100),@emailProfile varchar(100)
DECLARE @subjectPrefix varchar(100)
DECLARE @maxWorkerThreads int, @maxRunnableTasks int, @SchedulerInfoAge int
DECLARE @maxSOSWaitStat int, @maxTokenAndPermUserStoreMem int
DECLARE @maxMinutesSinceLastRiskModDecision int

DECLARE @stage int -- used in the exception handling code

--------------------------------------
-- Set up configuration variables
SET @subjectPrefix = 'DNA Database Server: '

SELECT  @sendTo='dna-ops@bbc.co.uk',
		@emailProfile='GUIDE6-2 DNA Email Profile',
		@maxWorkerThreads = 300,    -- Number of worker threads the server is using
		@maxRunnableTasks = 5*8,    -- Total runnable tasks across all 8 CPUs
		@SchedulerInfoAge = 120,    -- The newest data in the SchedulerInfo table must be <= @SchedulerInfoAge seconds old
		@maxSOSWaitStat   = 400000, -- If the last SOS_SCHEDULER_YIELD wait is above this value, it sends an email
		@maxTokenAndPermUserStoreMem = 100, -- If this cache gets too big, we clear it out
		@maxMinutesSinceLastRiskModDecision = 10 -- If this many mins pass since a risk mod decision, raise an alert

BEGIN TRY
	--------------------------------------
	-- Do heart beat email
	DECLARE @lastHeartBeatEmail DATETIME, @heartBeatSubject varchar(100)
	SET @heartBeatSubject=@subjectPrefix+'Heart Beat'

	-- Find out when the last heart beat email was sent
	SELECT TOP 1 @lastHeartBeatEmail = sent_date FROM msdb.dbo.sysmail_sentitems
		WHERE subject=@heartBeatSubject
		ORDER BY sent_date DESC

	IF @lastHeartBeatEmail IS NULL OR DATEDIFF(hh,@lastHeartBeatEmail,getdate()) > 12
		EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@heartBeatSubject,@profile_name=@emailProfile

	--------------------------------------
	-- Check for problems
	DECLARE @lastProblemEmail DATETIME, @problemEmailSubject varchar(100)
	SET @problemEmailSubject=@subjectPrefix+'Problem detected'

	-- Find out when the last problem email was sent
	SELECT TOP 1 @lastProblemEmail = sent_date FROM msdb.dbo.sysmail_sentitems
		WHERE subject=@problemEmailSubject
		ORDER BY sent_date DESC

	IF @lastProblemEmail IS NULL OR DATEDIFF(mi,@lastProblemEmail,getdate()) > 10
	BEGIN
		DECLARE @problemEmailBody varchar(max);

set @stage=1
/*
******** Commented out by Mark N 28/9/2011
******** Currently not running the SQL Agent "Capture Scheduler Info" job
******** To start monitoring Scheduler Info again, re-enable the above job

		DECLARE @numRunnableTasks int, @numWorkerThreads int, @latestCapture DATETIME;
		WITH LatestSchedulerInfo AS
		(
			SELECT TOP 8 * FROM [GUIDE6-1].Performance.dbo.SchedulerInfo ORDER BY dt DESC
		)
		SELECT @numRunnableTasks=SUM(runnable_task_count),@latestCapture=max(dt),@numWorkerThreads=max(num_workers)
			FROM LatestSchedulerInfo
set @stage=2

		--------------------------------------
		-- Check that we have a recent capture, and email if we haven't
		IF DATEDIFF(s,@latestCapture,getdate()) > @SchedulerInfoAge
		BEGIN
			SELECT @problemEmailBody='Have not captured scheduler info for over '+CAST(@SchedulerInfoAge AS varchar)+' seconds'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END

		--------------------------------------
		-- Email if the number of runnable tasks is high
		IF @numRunnableTasks > @maxRunnableTasks AND @numWorkerThreads > @maxWorkerThreads
		BEGIN
			SELECT @problemEmailBody='Number of runnable tasks is '+cast(@numRunnableTasks AS varchar)+'.  This indicates the database is in trouble'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END

		--------------------------------------
		-- Email if the last captured SOS_SCHEDULER_YIELD signal wait time is high

set @stage=3
		DECLARE @lastSOSWaitStat int
		SELECT @lastSOSWaitStat = cc.signal_wait_time-cl.signal_wait_time 
			FROM [GUIDE6-1].SqlHealth.dbo.capture_waitstats_last cl
			INNER JOIN [GUIDE6-1].SqlHealth.dbo.capture_waitstats_current cc ON cl.wait_type=cc.wait_type
			WHERE cl.wait_type='SOS_SCHEDULER_YIELD'
set @stage=4

		IF @lastSOSWaitStat > @maxSOSWaitStat
		BEGIN
			SELECT @problemEmailBody='Last SOS_SCHEDULER_YIELD wait is '+cast(@lastSOSWaitStat AS varchar)
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END
**********************/

/***********************************************
Commented out on 1/3/2010, as this check is not really relevent on SQL Server 2005 SP3 64bit

		--------------------------------------
		-- If the TokenAndPermUserStore is too big, email and try and shrink the cache
set @stage=5
		DECLARE @TokenAndPermUserStoreMem float
		SELECT	@TokenAndPermUserStoreMem=(single_pages_kb + multi_pages_kb)/1024.0
		FROM	[GUIDE6-1].master.sys.dm_os_memory_clerks
		WHERE name='TokenAndPermUserStore'
set @stage=6

		IF @TokenAndPermUserStoreMem > @maxTokenAndPermUserStoreMem
		BEGIN
			SELECT @problemEmailBody='TokenAndPermUserStore memory use is '+cast(@TokenAndPermUserStoreMem AS varchar)+'.  Clearing the caches...'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile

			EXEC [GUIDE6-1].master.dbo.sp_executesql N'DBCC FREEPROCCACHE'
			EXEC [GUIDE6-1].master.dbo.sp_executesql N'DBCC FREESYSTEMCACHE(''ALL'') WITH MARK_IN_USE_FOR_REMOVAL'

			SELECT @problemEmailBody='Finished clearing the caches'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END
*****************************/

	set @stage=7

		--------------------------------------
		-- If it's been too long since a risk mod decision, send an email

		DECLARE @minsSinceLastRiskModDecision int
		SELECT @minsSinceLastRiskModDecision=datediff(minute,max(dateassessed),getdate()) FROM [GUIDE6-1].TheGuide.dbo.RiskModDecisionsForThreadEntries

		-- We add 5 mins to the "Last Posted" time, to give the Risk Mod system chance to process the post
		DECLARE @minsSinceLastPost int
		SELECT @minsSinceLastPost = datediff(minute,max(DatePosted),getdate())+5 FROM [GUIDE6-1].TheGuide.dbo.ThreadEntries

		IF @minsSinceLastRiskModDecision >= @maxMinutesSinceLastRiskModDecision AND @minsSinceLastRiskModDecision > @minsSinceLastPost
		BEGIN
			SELECT @problemEmailBody='It has been '+CAST(@minsSinceLastRiskModDecision AS varchar)+' minutes since a risk mod decision has been made'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END

	set @stage=8
	
		--------------------------------------------------------------
		-- Check to make sure that the delay between items entring the risk mod queue and leaving the queue is less than a given time in seconds
		DECLARE @LastProcessTime INT
		
		SELECT TOP 1 @LastProcessTime = DATEDIFF(minute, DatePosted, DateAssessed)
			FROM [GUIDE6-1].TheGuide.dbo.RiskModThreadEntryQueue
			WHERE dateassessed IS NOT NULL AND dateposted IS NOT NULL
			ORDER BY ThreadEntryID DESC

		IF @LastProcessTime > 20
		BEGIN
			SELECT @problemEmailBody='The latest risk mod item took '+CAST(@LastProcessTime AS varchar)+' seconds to be processed'
			EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@problemEmailSubject,@body=@problemEmailBody,@profile_name=@emailProfile
		END
		
	END		

END TRY
BEGIN CATCH
	DECLARE @tryCatchEmail varchar(max)
	SELECT @tryCatchEmail = 
		'CheckDNADatabaseServer Error:'+CHAR(10)+
		'Error number:   '+CAST(ERROR_NUMBER()   AS VARCHAR)+CHAR(10)+
		'Error severity: '+CAST(ERROR_SEVERITY() AS VARCHAR)+CHAR(10)+
		'Error state:    '+CAST(ERROR_STATE() AS VARCHAR)+CHAR(10)+
		'Error proc:     '+ERROR_PROCEDURE()+CHAR(10)+
		'Error line:     '+CAST(ERROR_LINE() AS VARCHAR)+CHAR(10)+
		'Error message:  '+ERROR_MESSAGE()+CHAR(10)+'stage: '+cast(@stage as varchar)

	EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject='CheckDNADatabaseServer Exception',@body=@tryCatchEmail,@profile_name=@emailProfile
END CATCH