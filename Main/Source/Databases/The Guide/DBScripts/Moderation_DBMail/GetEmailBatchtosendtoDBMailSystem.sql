CREATE PROCEDURE getemailbatchtosendtoDBMailSystem @batchsize int
AS  
EXEC openemailaddresskey; 

IF EXISTS(SELECT *	FROM tempdb.dbo.sysobjects
	WHERE ID = OBJECT_ID(N'tempdb..#tmpEmailBatch'))
BEGIN
	DROP TABLE #tmpEmailBatch
END

SELECT TOP (@batchsize) * INTO #tmpEmailBatch
FROM EMailQueue 
WHERE DateQueued IS NULL 
ORDER BY ID ASC

Declare @Id int;

WHILE EXISTS(Select * from #tmpEmailBatch)
Begin

	Declare @MailQueuedStatus as int, @mailItemId as int
	Declare @ToEmailAddress as varbinary(128), @FromEmailAddress as varbinary(128),
			@Subject as varbinary(128), @Body as varbinary(128)
	
	SELECT Top 1 
		 @Id = Id,
		 @ToEmailAddress = dbo.udf_decryptemailaddress(ToEmailAddress, ID),  
		 @FromEmailAddress = dbo.udf_decryptemailaddress(FromEmailAddress, ID),  
		 @Subject = dbo.udf_decrypttext(Subject, ID),  
		 @Body = dbo.udf_decrypttext(Body, ID)
	FROM #tmpEmailBatch 
	ORDER BY ID ASC
	
	EXEC @MailQueuedStatus = msdb.dbo.sp_send_dbmail
    @profile_name = 'DNA Moderation Email Profile',
    @recipients = @ToEmailAddress,
    @body = @Body,
    @subject = @Subject,
    @mailitem_id = @MailItemId output
    
	
	UPDATE EmailQueue 
	SET DBMailId = @MailItemId,
		DateQueued = (SELECT send_request_date from msdb.dbo.sysmail_allitems where mailitem_id = @MailItemId)
	where Id = @Id 
	
	DELETE FROM #tmpEmailBatch WHERE ID = @Id

End

