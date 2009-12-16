CREATE procedure createcommentforum @uid varchar(255), @url varchar(255), @title nvarchar(255), @siteid int, @moderationstatus int = NULL, @duration int = NULL, @newforumid int OUTPUT
AS
BEGIN
	IF (@@TRANCOUNT = 0)
	BEGIN
		RAISERROR ('createcommentforum cannot be called outside a transaction!!!',16,1)
		RETURN 50000
	END

	DECLARE @forumid int
	DECLARE @ErrorCode int
	DECLARE @curdate datetime
	SET @curdate = getdate()
	
	INSERT INTO FORUMS(title, 
						datecreated, 
						siteid, 
						canread, 
						canwrite, 
						threadcanread, 
						threadcanwrite, 
						alertinstantly,
						forumstyle,
						moderationstatus) 
					VALUES (@title, @curdate, @siteid, 1, 1, 1, 1, 0, 1, @moderationstatus)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	SET @forumid = @@IDENTITY
	
	-- Work out the date for when the forum will close. If the closingdate param is null or less than 0, then we take the value from the siteoptions
	-- A duration of 0 means no closing date!
	DECLARE @closingdate datetime
	IF (@duration IS NULL OR @duration < 0)
	BEGIN
		-- Work out the date from the site options
		SELECT @duration = Value FROM dbo.SiteOptions WHERE SiteID = @siteid AND Name = 'DefaultDuration' AND Section = 'CommentForum' AND Type = 0
		
		-- Check to see if the site had the option. If not, get the default site 0 option
		IF (@duration IS NULL OR @duration < 0)
			SELECT @duration = Value FROM dbo.SiteOptions WHERE SiteID = 0 AND Name = 'DefaultDuration' AND Section = 'CommentForum' AND Type = 0
			
		-- Update the closing date
		IF (@duration = 0)
			SET @closingdate = NULL
		ELSE
			SET @closingdate = DATEADD(DAY, @duration+1, @curdate);
	END
	ELSE IF (@duration > 0)
	BEGIN
		SET @closingdate = DATEADD(DAY, @duration+1, @curdate);
	END

	-- Make sure that the date actually gets rounded up to midnight!
	IF (@closingdate IS NOT NULL)
	BEGIN
		DECLARE @day varchar(2), @month varchar(2)
		SET @day = CAST(DATEPART(dd,@closingdate) as varchar(2))
		IF (LEN(@day) = 1)
			SET @day = '0' + @day
		SET @month = CAST(DATEPART(mm,@closingdate) as varchar(2))
		IF (LEN(@month) = 1)
			SET @month = '0' + @month
		SET @closingdate = CAST(DATEPART(YEAR,@closingdate) as varchar(4)) + @month + @day + ' 00:00:000'
	END

	INSERT INTO commentforums (forumid, siteid, uid, url, forumclosedate) values (@forumid, @siteid, @uid, @url, @closingdate)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode
		
	INSERT INTO ForumLastUpdated(forumid, lastupdated) values (@forumid, @curdate)

	SELECT @newforumid = @forumid
	RETURN 0
END