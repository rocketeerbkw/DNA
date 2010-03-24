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
