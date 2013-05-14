CREATE PROCEDURE getemailbatchtosendtoDBMailSystem 
AS  
EXEC openemailaddresskey; 

Declare @Id int;

WHILE (Select Count(*) from EmailQueue where DateQueued IS NULL) > 0
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
	FROM EmailQueue 
	WHERE DateQueued IS NULL
	
	
	EXEC @MailQueuedStatus = msdb.dbo.sp_send_dbmail
    @profile_name = 'DNA Moderation Email Profile (vp-dev-dna-db1)', -- change the profile name based on the environment and Database Mail Configuration
    @recipients = @ToEmailAddress,
    @body = @Body,
    @subject = @Subject,
    @mailitem_id = @MailItemId output
    
    --TODO - error handling
	
	UPDATE EmailQueue 
	SET DBMailId = @MailItemId,
		DateQueued = (SELECT send_request_date from msdb.dbo.sysmail_allitems where mailitem_id = @MailItemId)
	where Id = @Id 

End

