CREATE PROCEDURE stopwatchinguserjournal @userid INT, @watcheduserid INT, @currentsiteid INT =0 
AS
BEGIN
	
	DECLARE @username VARCHAR(255) 
	DECLARE @firstnames VARCHAR(255) 
	DECLARE @lastname VARCHAR(255) 
	DECLARE @sitesuffix VARCHAR(255) 
	DECLARE @title VARCHAR(255) 
	DECLARE @area VARCHAR(255) 
	DECLARE @journal INT	
	DECLARE @status INT	
	DECLARE @taxonomynode INT	
	DECLARE @active INT	
	
	DECLARE @ErrorCode INT
	
	BEGIN TRANSACTION
	
	SELECT @username = u.userName, 
				@firstnames = u.firstnames, 
				@lastname = u.Lastname, 
				@area = u.area, 
				@status= u.status, 
				@taxonomynode = u.taxonomynode, 
				@journal = j.forumid, 
				@active = u.active, 
				@title = p.title, 
				@sitesuffix = p.sitesuffix 
	FROM users AS u WITH(NOLOCK) LEFT JOIN preferences AS p WITH(NOLOCK) ON (p.userid = u.userid) and (p.siteid = @currentsiteid)
	inner join Journals J with(nolock) on J.UserID = U.UserID and J.SiteID = @currentsiteid
	WHERE u.userID = @watcheduserid
	
	DELETE 
	FROM FaveForums 
	WHERE UserID = @userid AND ForumID = @journal
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	COMMIT TRANSACTION
		
	SELECT "userid" = @watcheduserid,
				"userName" = @username, 
				"firstnames" = @firstnames, 
				"lastname" = @lastname, 
				"area" = @area, 
				"status" = @status, 
				"taxonomynode" = @taxonomynode, 
				"journal" = @journal, 
				"active" = @active, 
				"title" = @title, 
				"sitesuffix" = @sitesuffix
	
	RETURN 0
END
