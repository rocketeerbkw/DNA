CREATE PROCEDURE [dbo].[CheckDNADatabaseServer]
AS

--------------------------------------
-- Configuration Variables
DECLARE @sendTo varchar(100),@emailProfile varchar(100)
DECLARE @subjectPrefix varchar(100)
DECLARE @maxWorkerThreads int, @maxRunnableTasks int, @SchedulerInfoAge int

--------------------------------------
-- Set up configuration variables
SET @subjectPrefix = 'Check DNA Database Server: '

SELECT  @sendTo='mark.neves@gmail.com;mark.neves@bbc.co.uk',
		@emailProfile='DNA Email Server Profile',
		@maxWorkerThreads = 300, -- Number of worker threads the server is using
		@maxRunnableTasks = 5*8, -- Total runnable tasks across all 8 CPUs
		@SchedulerInfoAge = 120  -- The newest data in the SchedulerInfo table must be <= @SchedulerInfoAge seconds old

BEGIN TRY
	--------------------------------------
	-- Do heart beat email
	DECLARE @lastHeartBeatEmail DATETIME, @heartBeatSubject varchar(100)
	SET @heartBeatSubject=@subjectPrefix+'Heart Beat'

	-- Find out when the last heart beat email was sent
	SELECT TOP 1 @lastHeartBeatEmail = sent_date FROM msdb.dbo.sysmail_sentitems
		WHERE subject=@heartBeatSubject
		ORDER BY sent_date DESC

	IF @lastHeartBeatEmail IS NULL OR DATEDIFF(mi,@lastHeartBeatEmail,getdate()) > 12
		EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@heartBeatSubject,@profile_name=@emailProfile

	--------------------------------------
	-- Check runnable tasks
	DECLARE @runnableTaskSubject varchar(100)
	SET @runnableTaskSubject=@subjectPrefix+'Runnable Tasks'

	DECLARE @numRunnableTasks int, @numWorkerThreads int, @latestCapture DATETIME;
	DECLARE @sendEmail int, @runnableTasksEmailBody varchar(max);
	WITH LatestSchedulerInfo AS
	(
		SELECT TOP 8 * FROM [GUIDE5\SQL2005].Performance.dbo.SchedulerInfo ORDER BY dt DESC
	)
	SELECT @numRunnableTasks=SUM(runnable_task_count),@latestCapture=max(dt),@numWorkerThreads=max(num_workers)
		FROM LatestSchedulerInfo

	IF DATEDIFF(s,@latestCapture,getdate()) > @SchedulerInfoAge
	BEGIN
		SELECT @sendEmail=1, @runnableTasksEmailBody='Have not captured scheduler info for over '+CAST(@SchedulerInfoAge AS varchar)+' seconds'
	END

	IF @numRunnableTasks > @maxRunnableTasks AND @numWorkerThreads > @maxWorkerThreads
	BEGIN
		SELECT @sendEmail=1, @runnableTasksEmailBody='Number of runnable tasks > '+cast(@maxRunnableTasks AS varchar)
	END

	IF @sendEmail=1
		EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject=@runnableTaskSubject,@body=@runnableTasksEmailBody,@profile_name=@emailProfile
		

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
		'Error message:  '+ERROR_MESSAGE()+CHAR(10)

	EXEC msdb.dbo.sp_send_dbmail @recipients=@sendTo,@subject='CheckDNADatabaseServer Exception',@body=@tryCatchEmail,@profile_name=@emailProfile
END CATCH


