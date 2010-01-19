CREATE PROCEDURE processeventqueue
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	
		DECLARE @TopEventID INT
		SELECT @TopEventID = MAX(EventID) FROM dbo.EventQueue

		-- Update the EMailEventQueue with items from the eventqueue that matches any users alerts
		EXEC dbo.generateemailevents @TopEventID
		
		-- Update the SNeSActivityQueue with appropriate EventQueue items
		EXEC dbo.generatesnesevents @TopEventID
		
		EXEC generateexmodevents @TopEventID

		-- Clear the EventQueue
		DELETE FROM dbo.EventQueue WHERE EventID <= @TopEventID
		
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
		RETURN ERROR_NUMBER()
		
	END CATCH
	
	WAITFOR DELAY '00:00:10'
END