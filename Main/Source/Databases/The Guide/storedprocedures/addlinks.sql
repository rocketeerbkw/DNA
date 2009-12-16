Create Procedure addlinks @sourcetype varchar(50), @sourceid int,
								@desttype varchar(50), @destid int,
								@title varchar(255),
								@description varchar(255),
								@group varchar(50),
								@ishidden int,
								@teamid int,
								@url varchar(512),
								@relationship varchar(30) = NULL,
								@submitterid int,
								@destsiteid int
As
BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	
	IF (@desttype = 'external')
	BEGIN
		INSERT INTO ExternalURLs (URL) VALUES (@url);
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'result' = 'failed'
			RETURN @ErrorCode
		END
		
		SELECT @destid = SCOPE_IDENTITY()
	END
	
	DECLARE @NewLinkID int
	
	INSERT INTO Links (SourceType, SourceID, DestinationType, DestinationID, Title, LinkDescription, 
			DateLinked, Explicit, Type, Private, TeamID, Relationship, SubmitterID, DestinationSiteID )
		VALUES(@sourcetype, @sourceid, @desttype, @destid, @title, @description, 
			getdate(), 0, @group, @ishidden, @teamid, @relationship, @submitterid, @destsiteid )
				
	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		declare @hidden int
		select @hidden = Private FROM Links
			WHERE SourceType = @sourcetype AND DestinationType = @desttype AND SourceID = @sourceid AND DestinationID = @destid
		IF (@hidden = 1)
			SELECT 'result' = 'alreadylinkedhidden'
		ELSE
			SELECT 'result' = 'alreadylinked'
		return (0)
	END
	ELSE
	BEGIN
		SET @NewLinkID = SCOPE_IDENTITY()
	END	
		
COMMIT TRANSACTION

IF (@sourcetype like 'club')
BEGIN
	IF (@desttype like 'external')
	BEGIN
		EXEC addtoeventqueueinternal 'ET_NEWLINKADDED', @sourceid, 'IT_CLUB', @NewLinkID, 'IT_URL', @submitterid
	END
	ELSE
	BEGIN
		EXEC addtoeventqueueinternal 'ET_NEWLINKADDED', @sourceid, 'IT_CLUB', @destid, 'IT_H2G2', @submitterid
	END
END

IF (@desttype like 'article')
BEGIN

	DECLARE @siteid int
	DECLARE @entryid int
	
	SELECT @siteid = SiteID, @entryid = EntryID FROM GuideEntries WITH (NOLOCK) 
	WHERE h2g2id = @destid
	
	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc = 'BookmarkArticle',
										  @siteid = @siteid,
										  @entryid = @entryid										  										  
										  
	IF (@ErrorCode <> 0 ) 
	BEGIN
		RETURN @ErrorCode;												  
	END
END

select 'result' = 'success'
