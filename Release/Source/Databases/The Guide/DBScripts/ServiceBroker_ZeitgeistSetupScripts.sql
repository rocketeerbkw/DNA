/* Enable Service Broker on your database. */
ALTER DATABASE [TheGuide] SET ENABLE_BROKER; -- will need to change this for SmallGuide

/**********************************************/
/*************** 	MESSAGES	***************/
/**********************************************/
-- create
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_PostToForum];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy];
CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction];

-- select
SELECT *
FROM sys.service_message_types;

-- delete
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_PostToForum];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy];
DROP MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction];
/**********************************************/
/************ 	END OF MESSAGES		***********/
/**********************************************/


/**********************************************/
/*************** 	CONTRACTS	***************/
/**********************************************/
-- Create
CREATE CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract] ([//bbc.co.uk/dna/Zeitgeist_PostToForum] SENT BY INITIATOR, 
															[//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry] SENT BY INITIATOR,
															[//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy] SENT BY INITIATOR,
															[//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy] SENT BY INITIATOR, 
															[//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote] SENT BY INITIATOR,
															[//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote] SENT BY INITIATOR,
															[//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy] SENT BY INITIATOR, 
															[//bbc.co.uk/dna/Zeitgeist_CompleteClubAction] SENT BY INITIATOR
																);

-- select
select *
  from sys.service_contracts;

-- delete
DROP CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract];
/**********************************************/
/************ 	END OF CONTRACTS	***********/
/**********************************************/

/**********************************************/
/****************	 QUEUES		***************/
/**********************************************/
-- Create
CREATE QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON, PROCEDURE_NAME = dbo.processzeitgeisteventresponse, MAX_QUEUE_READERS = 4, EXECUTE AS SELF);

CREATE QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON, PROCEDURE_NAME = dbo.processzeitgeistevent, MAX_QUEUE_READERS = 4, EXECUTE AS SELF);

-- select 
select *
  from sys.service_queues

-- disable
ALTER QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue] WITH STATUS = ON ; 

ALTER QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] WITH STATUS = ON ;

-- stop auto firing of processing SPs
ALTER QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON ) ; 

ALTER QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON ) ;

-- delete 
DROP QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue];

DROP QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue];

/**********************************************/
/***********	END OF QUEUES		***********/
/**********************************************/


/**********************************************/
/****************	 SERVICES	***************/
/**********************************************/
-- create
CREATE SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService] ON QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue];

CREATE SERVICE [//bbc.co.uk/dna/ReceiveZeitgeistEventService] ON QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] ([//bbc.co.uk/dna/ZeitgeistEventContract]); 

-- select 
select *
  from sys.services

-- delete 
DROP SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService];

DROP SERVICE [//bbc.co.uk/dna/ReceiveZeitgeistEventService];

/**********************************************/
/***********	END OF SERVICES		***********/
/**********************************************/


/**********************************************/
/*************** ACTIVATION SPs	***************/
/**********************************************/
CREATE PROCEDURE processzeitgeistevent
AS
	DECLARE @message_body XML; 
	DECLARE @message_type SYSNAME; 
	DECLARE @dialog	UNIQUEIDENTIFIER; 

	DECLARE @EventDescription VARCHAR(255)
	DECLARE @SiteID		INT
	DECLARE @EntryID	INT
	DECLARE @UserID		INT
	DECLARE @ForumID	INT
	DECLARE @ClubID		INT
	DECLARE @ThreadID	INT
	DECLARE @NodeID		INT

	WHILE (1=1)
	BEGIN
		SELECT @SiteID = 0 
		SELECT @EntryID = 0
		SELECT @UserID = 0
		SELECT @ForumID = 0
		SELECT @ClubID = 0
		SELECT @ThreadID = 0

		BEGIN TRANSACTION

		WAITFOR (
			RECEIVE top(1)
				@message_type	= message_type_name, 
				@message_body	= message_body, 
				@dialog			= conversation_handle
			FROM [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue]
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
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_PostToForum')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @EntryID = msg.evt.value('ENTRYID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int'),
					   @ThreadID = msg.evt.value('THREADID[1]', 'int'),
					   @ForumID = msg.evt.value('FORUMID[1]', 'int'), 
					   @ClubID = msg.evt.value('CLUBID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription, 
											 @siteid 		= @SiteID, 
											 @entryid		= @EntryID , 
											 @userid		= @UserID, 
											 @clubid		= @ClubID, 
											 @threadid		= @ThreadID, 
											 @forumid		= @ForumID;

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @EntryID = msg.evt.value('ENTRYID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription, 
											 @siteid 		= @SiteID, 
											 @entryid		= @EntryID , 
											 @userid		= @UserID;

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @EntryID = msg.evt.value('ENTRYID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @NodeID = msg.evt.value('NODEID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription, 
											 @siteid 		= @SiteID, 
											 @entryid		= @EntryID, 
											 @nodeid		= @NodeID, 
											 @userid		= @UserID;

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @ClubID = msg.evt.value('CLUBID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @NodeID = msg.evt.value('NODEID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription, 
											 @siteid 		= @SiteID, 
											 @clubid		= @ClubID, 
											 @nodeid		= @NodeID, 
											 @userid		= @UserID;

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @ClubID = msg.evt.value('CLUBID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @EntryID = msg.evt.value('ENTRYID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int'),
					   @ThreadID = msg.evt.value('THREADID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription,
											 @siteid		= @SiteID,  
											 @userid		= @UserID,
											 @clubid		= @ClubID, 
											 @entryid		= @EntryID, 
											 @threadid		= @ThreadID

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @ClubID = msg.evt.value('CLUBID[1]', 'int'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @EntryID = msg.evt.value('ENTRYID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int'),
					   @ThreadID = msg.evt.value('THREADID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription,
											 @siteid		= @SiteID,  
											 @userid		= @UserID,
											 @clubid		= @ClubID, 
											 @entryid		= @EntryID, 
											 @threadid		= @ThreadID

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @NodeID = msg.evt.value('NODEID[1]', 'int'),
					   @UserID = msg.evt.value('USERID[1]', 'int'),
					   @ThreadID = msg.evt.value('THREADID[1]', 'int'), 
					   @ForumID = msg.evt.value('FORUMID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription,
											 @siteid		= @SiteID,  
											 @userid		= @UserID,
											 @threadid		= @ThreadID, 
											 @nodeid		= @NodeID, 
											 @forumid		= @ForumID

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		ELSE IF (@message_type = '//bbc.co.uk/dna/Zeitgeist_CompleteClubAction')
		BEGIN
			BEGIN TRY
				SELECT @EventDescription = msg.evt.value('DESCRIPTION[1]', 'varchar(255)'), 
					   @SiteID = msg.evt.value('SITEID[1]', 'int'),
					   @ClubID = msg.evt.value('CLUBID[1]', 'int')
				  FROM @message_body.nodes('/ZEITGEISTEVENT') AS msg(evt);

				EXEC dbo.updatecontentsignif @activitydesc	= @EventDescription,
											 @siteid		= @SiteID,  
											 @clubid		= @ClubID

				PRINT 'Called updatecontentsignif for event ' + @EventDescription; -- FOR DEV ONLY TODO - remove when going live.
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH; 

			END CONVERSATION @dialog
		END
		COMMIT TRANSACTION
	END -- END WHILE 

-- processzeitgeisteventresponse
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
/* End of creating activation stored procedures. */

/**********************************************/
/************ END OF ACTIVATION SPs	***********/
/**********************************************/

/**********************************************/
/***************	ENDPOINTS	***************/
/**********************************************/
-- Use this if you need to clean up conversation endpoint that have been closed but are still hanging around (service broker should clear them out 30 mins after they are closed). 
DECLARE @conversation_handle UNIQUEIDENTIFIER

DECLARE OrphenedEndPoints_Cursor CURSOR FAST_FORWARD FOR 
 SELECT conversation_handle
   FROM sys.conversation_endpoints

OPEN OrphenedEndPoints_Cursor;

FETCH NEXT FROM OrphenedEndPoints_Cursor INTO @conversation_handle;

WHILE (@@fetch_status = 0)
BEGIN
	END CONVERSATION @conversation_handle WITH CLEANUP

	FETCH NEXT FROM OrphenedEndPoints_Cursor INTO @conversation_handle;
END

CLOSE OrphenedEndPoints_Cursor;
DEALLOCATE OrphenedEndPoints_Cursor;

/**********************************************/
/***********	END OF ENDPOINTS	***********/
/**********************************************/