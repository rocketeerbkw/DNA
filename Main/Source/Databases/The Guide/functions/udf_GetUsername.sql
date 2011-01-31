CREATE FUNCTION udf_getusername (@siteid int, @userid int)
RETURNS varchar(255)
WITH SCHEMABINDING
AS
BEGIN

	/*
		Function: Function returns the username or sitesuffix depening on siteoptions

		Params:
			@siteid - SiteID.
			@userid - the userid
			

		Returns: varchar(255) -username 
	*/

	DECLARE @Value varchar(255)

	declare @UseSiteSuffix varchar(6000)
	IF EXISTS(SELECT 1 FROM dbo.SiteOptions WITH (NOLOCK) WHERE Siteid=@siteid AND Section='General' AND Name='UseSiteSuffix')
	BEGIN 
		-- Site specific setting. 
		SELECT @UseSiteSuffix = Value
		  FROM dbo.SiteOptions WITH (NOLOCK)
		 WHERE Siteid = @siteid
		   AND Section = 'General' 
		   AND Name = 'UseSiteSuffix'
	END
	ELSE 
	BEGIN
		-- Default setting. 
		SELECT @UseSiteSuffix = Value
		  FROM dbo.SiteOptions WITH (NOLOCK)
		 WHERE Siteid = 0 -- Default
		   AND Section = 'General' 
		   AND Name = 'UseSiteSuffix'
	END

	if(@UseSiteSuffix = '1')
	BEGIN
		select @Value = sitesuffix
		from dbo.preferences
		where siteid=@siteid and userid = @userid
	
	END
	ELSE
	BEGIN
		select @Value = username
		from dbo.users
		where userid = @userid
	END
	
	RETURN @Value
END