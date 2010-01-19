CREATE PROCEDURE makepreviewtopicsactiveforsiteid @isiteid INT, @ieditorid INT
AS
BEGIN
	
	BEGIN TRANSACTION
		
	--topicid placeholder variable
	DECLARE @iTopicID INT
	DECLARE @ErrorCode INT 
	
	--declare browse cursor. Select All Preview and Preview Archived topics
	DECLARE topic_cursor CURSOR DYNAMIC
	FOR SELECT TopicID FROM dbo.Topics WITH(NOLOCK) WHERE SiteID = @isiteid AND TopicStatus IN (1,4)
	
	--open cursor
	OPEN topic_cursor

	--fetch first record, if any
	FETCH NEXT FROM topic_cursor INTO @iTopicID
	PRINT @iTopicID

	--continue until there are no more records
	WHILE @@FETCH_STATUS = 0
	BEGIN
			--process current record
			EXEC @ErrorCode = MakePreviewTopicActiveForSiteID @isiteid, @iTopicID, @ieditorid
			
			--return if error occurs
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				CLOSE topic_cursor
				DEALLOCATE topic_cursor
				RETURN @ErrorCode
				EXEC Error @ErrorCode
			END
						
		--get next row in resultset
 		FETCH NEXT FROM topic_cursor INTO @iTopicID
	END

	--close cursor
	CLOSE topic_cursor
	DEALLOCATE topic_cursor
				
	COMMIT TRANSACTION 
	RETURN 0
END