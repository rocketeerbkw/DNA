CREATE PROCEDURE UpdateEmailQueueSentStatus @batchsize int
AS  

IF EXISTS(SELECT *	FROM tempdb.dbo.sysobjects
	WHERE ID = OBJECT_ID(N'tempdb..#tmpEmailBatchSentStatus'))
BEGIN
	DROP TABLE #tmpEmailBatchSentStatus
END

SELECT TOP (@batchsize) * INTO #tmpEmailBatchSentStatus
FROM dbo.EMailQueue 
WHERE DateSent IS NULL 
ORDER BY ID ASC

Declare @Id int;

WHILE EXISTS(Select * from #tmpEmailBatchSentStatus)
BEGIN

	DECLARE @SentStatus nvarchar(10)
	DECLARE @MailId int
	DECLARE @DateSent DATETIME
	
	SELECT TOP 1 @Id = Id FROM #tmpEmailBatchSentStatus
	
	SELECT @MailId = DBMailId FROM EmailQueue WHERE Id = @Id
	
	SELECT @SentStatus = UPPER(LTRIM(RTRIM(sent_status))), @DateSent = sent_date
	FROM msdb.dbo.sysmail_allitems WHERE mailitem_id = @MailId

	
	IF @SentStatus = 'SENT'
	BEGIN
		UPDATE EmailQueue 
		SET DateSent = @DateSent,
			LastFailedReason = NULL
		WHERE ID = @Id
	END
	ELSE
	BEGIN
		UPDATE EQ
		SET EQ.LastFailedReason = DBEL.description, 
			EQ.DateSent = NULL
		FROM dbo.EmailQueue EQ
		INNER JOIN msdb.dbo.sysmail_event_log DBEL
		ON EQ.DBMailId = DBEL.mailitem_id
		WHERE EQ.Id = @Id
	END
	
	DELETE FROM #tmpEmailBatchSentStatus WHERE ID = @Id
	
END
