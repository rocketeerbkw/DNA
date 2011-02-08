CREATE PROCEDURE processeventqueue @numiterations int=6, @sleeptimeinsecs int=10
AS
BEGIN
	BEGIN TRY
		DECLARE @sleeptime DATETIME
		SET @sleeptime=DATEADD(ss,@sleeptimeinsecs,'00:00:00')

		WHILE (@numiterations > 0)
		BEGIN

			BEGIN TRANSACTION
	
			DECLARE @TopEventID INT
			SELECT @TopEventID = MAX(EventID) FROM dbo.EventQueue

			-- Update the EMailEventQueue with items from the eventqueue that matches any users alerts
			EXEC dbo.generateemailevents @TopEventID
		
			-- Update the SNeSActivityQueue with appropriate EventQueue items
			EXEC dbo.generatesnesevents @TopEventID
		
			EXEC generateexmodevents @TopEventID

			-- Update the BIEventQueue with the events relevent to BI
			EXEC dbo.generatebievents @TopEventID
		
			-- Update the generatesiteevents with the events
			EXEC dbo.generatesiteevents @TopEventID

			-- Clear the EventQueue
			DELETE FROM dbo.EventQueue WHERE EventID <= @TopEventID
		
			COMMIT TRANSACTION

			SET @numiterations=@numiterations-1

			IF @numiterations > 0
				WAITFOR DELAY @sleeptime
		END
		
	END TRY
	BEGIN CATCH

		if @@TRANCOUNT > 0
			ROLLBACK TRAN

		RETURN ERROR_NUMBER()
		
	END CATCH
END