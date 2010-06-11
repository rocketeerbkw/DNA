/*
TODO: test whether the date part of this SP works okay

Note that currently this SP doesn't handle updating the users group membership
*/

Create Procedure updateuser2	@userid int,
								@siteid int,
								@email varchar(255) = NULL, 
								@username nvarchar(255) = NULL,
								@cookie varchar(255) = NULL,
								@password varchar(255) = NULL,
								@firstnames varchar(255) = NULL,
								@lastname varchar(255) = NULL,
								--@masthead int = NULL,
								@journal int = NULL,
								@active int = NULL,
								@status int = NULL,
								@sinbin int = NULL,
								@anonymous int = NULL,
								@latitude real = NULL,
								@longitude real = NULL,
								@datejoined datetime = NULL,
								@datereleased datetime = NULL,
								@prefskin varchar(255) = NULL,
								@prefusermode int = NULL,
								@prefforumstyle int = NULL,
								@prefforumthreadstyle int = NULL,
								@prefforumshowmaxposts int = NULL,
								@prefreceiveweeklymailshot int = NULL,
								@prefreceivedailyupdates int = NULL,
								@agreedterms int = NULL,
								@prefxml varchar(1024) = NULL,
								@postcode varchar(20) = NULL,
								@area varchar(100) = NULL,
								@taxonomynode int = NULL,
								@title varchar(255) = NULL,
								@sitesuffix varchar(255) = NULL,
								@region varchar(255) = NULL,
								@acceptsubscriptions int = NULL
As
declare @setuser nvarchar(2048)
declare @setpref nvarchar(2048)
declare @comma varchar(5)
declare @EscapedUserName nvarchar(1200)
IF @username IS NOT NULL
BEGIN
	SELECT @EscapedUserName = REPLACE(@username, '<', '&lt;') -- N.B. User Name can get truncated here is multiple < or > chars passed in. 
	SELECT @EscapedUserName = REPLACE(@EscapedUserName, '>', '&gt;')
END
SELECT @comma = ''
SELECT @setuser = ''
/*
IF NOT (@masthead IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Masthead = ' + CAST(@masthead AS varchar(50))
SELECT @comma = ' , '
END
*/
IF NOT (@journal IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'Journal = @i_journal'
  SELECT @comma = ' , '
END
IF NOT (@active IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Active = @i_active'
SELECT @comma = ' , '
END
IF NOT (@status IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Status = @i_status'
SELECT @comma = ' , '
END
IF NOT (@sinbin IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'SinBin = @i_sinbin'
  SELECT @comma = ' , '
END
IF NOT (@latitude IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'Latitude = @i_latitude'
  SELECT @comma = ' , '
END
IF NOT (@longitude IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'Longitude = @i_longitude'
  SELECT @comma = ' , '
END
IF NOT (@anonymous IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Anonymous = @i_anonymous'
SELECT @comma = ' , '
END
IF NOT (@email IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'email = @i_email'
SELECT @comma = ' , '
END
IF NOT (@EscapedUserName IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'UserName = @i_username'
SELECT @comma = ' , '
END
IF NOT (@postcode IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Postcode = @i_postcode'
SELECT @comma = ' , '
END
IF NOT (@area IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Area = @i_area'
SELECT @comma = ' , '
END
IF NOT (@taxonomynode IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'TaxonomyNode = @i_taxonomynode'
SELECT @comma = ' , '
END
IF NOT (@cookie IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'Cookie = @i_cookie'
  SELECT @comma = ' , '
END
IF NOT (@password IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'Password = @i_password'
SELECT @comma = ' , '
END
IF NOT (@firstnames IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'FirstNames = @i_firstnames'
SELECT @comma = ' , '
END
IF NOT (@lastname IS NULL)
BEGIN
SELECT @setuser = @setuser + @comma + 'LastName = @i_lastname'
SELECT @comma = ' , '
END
IF NOT (@datejoined IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'DateJoined = @i_datejoined'
  SELECT @comma = ' , '
END
IF NOT (@datereleased IS NULL)
BEGIN
  SELECT @setuser = @setuser + @comma + 'DateReleased = @i_datereleased'
  SELECT @comma = ' , '
END
IF NOT (@region IS NULL)
BEGIN
	SELECT @setuser = @setuser + @comma + 'Region = @i_region'
	SET @comma = ' , '
END
IF NOT (@acceptsubscriptions IS NULL)
BEGIN
	SELECT @setuser = @setuser + @comma + 'AcceptSubscriptions = @i_acceptsubscriptions'
END

SELECT @setpref = ''
SELECT @comma = ''
IF NOT (@prefskin IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefSkin = @i_prefskin'
  SELECT @comma = ' , '
END
IF NOT (@prefxml IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefXML = @i_prefxml'
  SELECT @comma = ' , '
END
IF NOT (@prefusermode IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefUserMode = @i_prefusermode'
  SELECT @comma = ' , '
END
IF NOT (@prefforumstyle IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefForumStyle = @i_prefforumstyle'
  SELECT @comma = ' , '
END
IF NOT (@prefforumthreadstyle IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefForumThreadStyle = @i_prefforumthreadstyle'
  SELECT @comma = ' , '
END
IF NOT (@prefforumshowmaxposts IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefForumShowMaxPosts = @i_prefforumshowmaxposts'
  SELECT @comma = ' , '
END
IF NOT (@prefreceiveweeklymailshot IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefReceiveWeeklyMailshot = @i_prefreceiveweeklymailshot'
  SELECT @comma = ' , '
END
IF NOT (@prefreceivedailyupdates IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'PrefReceiveDailyUpdates = @i_prefreceivedailyupdates'
  SELECT @comma = ' , '
END
IF NOT (@agreedterms IS NULL)
BEGIN
  SELECT @setpref = @setpref + @comma + 'AgreedTerms = @i_agreedterms'
  SELECT @comma = ' , '
END
IF NOT (@title IS NULL)
BEGIN
	SELECT @setpref = @setpref +@comma + 'Title = @i_title'
	SELECT @comma = ' , '
END
IF NOT (@sitesuffix IS NULL)
BEGIN
	SELECT @setpref = @setpref +@comma + 'SiteSuffix = @i_sitesuffix'
	SELECT @comma = ' , '
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF (@setuser <> '')
BEGIN
	declare @query nvarchar(4000)
	SELECT @query = 'UPDATE Users SET ' + @setuser + ' WHERE UserID = @i_userid'
	
	--EXEC (@query)
	exec sp_executesql @query,
	N'@i_journal int,
	@i_active int,
	@i_status int,
	@i_sinbin int,
	@i_latitude float,
	@i_longitude float,
	@i_anonymous int,
	@i_email varchar(255),
	@i_username varchar(1200),
	@i_postcode varchar(20),
	@i_area varchar(100),
	@i_taxonomynode int,
	@i_cookie varchar(255),
	@i_password varchar(255),
	@i_firstnames varchar(255),
	@i_lastname varchar(255),
	@i_datejoined datetime,
	@i_datereleased datetime,
	@i_region varchar(255),
	@i_userid int,
	@i_acceptsubscriptions int',
	@i_journal = @journal,
	@i_active = @active,
	@i_status = @status,
	@i_sinbin = @sinbin,
	@i_latitude = @latitude,
	@i_longitude = @longitude,
	@i_anonymous = @anonymous,
	@i_email = @email,
	@i_username = @EscapedUserName,
	@i_postcode = @postcode,
	@i_area = @area,
	@i_taxonomynode = @taxonomynode,
	@i_cookie = @cookie,
	@i_password = @password,
	@i_firstnames = @firstnames,
	@i_lastname = @lastname,
	@i_datejoined = @datejoined,
	@i_datereleased = @datereleased,
	@i_region = @region,
	@i_userid = @userid,
	@i_acceptsubscriptions = @acceptsubscriptions
	
	
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

IF (@setpref <> '')
BEGIN
	declare @query2 nvarchar(4000)
	IF ((SELECT COUNT(*) FROM Preferences WHERE UserID = @userid AND SiteID = @siteid) = 0)
	BEGIN
		exec @ErrorCode = setdefaultpreferencesforuser @userid, @siteid
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

	SELECT @query2 = 'UPDATE Preferences SET ' + @setpref + ' WHERE UserID = @i_userid AND SiteID = @i_siteid'
	--print @query2
	--EXEC (@query2)
	
	exec sp_executesql @query2,
	
	N'@i_prefskin varchar(255),
	@i_prefxml varchar(1024),
	@i_prefusermode int,
	@i_prefforumstyle int,
	@i_prefforumthreadstyle int,
	@i_prefforumshowmaxposts int,
	@i_prefreceiveweeklymailshot int,
	@i_prefreceivedailyupdates int,
	@i_agreedterms int,
	@i_title varchar(255),
	@i_sitesuffix varchar(255),
	@i_userid int,
	@i_siteid int',
	
	@i_prefskin = @prefskin,
	@i_prefxml = @prefxml,
	@i_prefusermode = @prefusermode,
	@i_prefforumstyle = @prefforumstyle,
	@i_prefforumthreadstyle = @prefforumthreadstyle,
	@i_prefforumshowmaxposts = @prefforumshowmaxposts,
	@i_prefreceiveweeklymailshot = @prefreceiveweeklymailshot,
	@i_prefreceivedailyupdates = @prefreceivedailyupdates,
	@i_agreedterms = @agreedterms,
	@i_title = @title,
	@i_sitesuffix = @sitesuffix,
	@i_userid = @userid,
	@i_siteid = @siteid
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

COMMIT TRANSACTION

return (0)
