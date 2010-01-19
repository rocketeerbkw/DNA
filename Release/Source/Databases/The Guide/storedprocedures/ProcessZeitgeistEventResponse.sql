CREATE PROCEDURE processzeitgeisteventresponse
AS
	DECLARE @message_body XML; 
	DECLARE @message_type SYSNAME; 
	DECLARE @dialog	UNIQUEIDENTIFIER; 

	WHILE (1=1)
	BEGIN
		BEGIN TRANSACTION

		WAITFOR (
			RECEIVE top(1)
				@message_type	= message_type_name, 
				@dialog			= conversation_handle
			FROM [//bbc.co.uk/dna/SendZeitgeistEventQueue]
		), TIMEOUT 2000

		IF (@@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION
			BREAK; -- Break out of SP if nothing in queue.
		END
		ELSE IF (@message_type = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
		BEGIN
			-- TODO : proper error logging and handling
			PRINT 'End Dialog for dialog # ' + cast(@dialog as nvarchar(40))
			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = 'http://schemas.microsoft.com/SQL/ServiceBroker/Error')
		BEGIN
			-- TODO : proper error logging and handling
			PRINT 'Dialog ERROR dialog # ' + cast(@dialog as nvarchar(40))
			END CONVERSATION @dialog
		END
		ELSE 
		BEGIN
			PRINT 'Don''t recognise message_type ' + cast(@message_type as nvarchar(255)) + ' dialog # ' + cast(@dialog as nvarchar(40)) + '. Ending converstation anyway.'
			END CONVERSATION @dialog
		END 
		COMMIT TRANSACTION
	END -- END WHILE 
