CREATE FUNCTION udf_getsiteoptionsetting (@siteid int, @section varchar(50), @name varchar(50))
RETURNS varchar(6000)
WITH SCHEMABINDING
AS
BEGIN

	/*
		Function: Function returns site option setting applying to the site. I.e. Returns default setting if no site specific setting is available. 

		Params:
			@siteid - SiteID.
			@section - Section the SiteOption is in. 
			@name - Name of SiteOption.

		Returns: varchar(6000) - Setting of SiteOption for the site. 
								 N.B. It is the callers responsibility to CAST to appropriate type. 
								 NULL returned if SiteOption not found. 
	*/

	DECLARE @Value varchar(6000)

	IF EXISTS(SELECT 1 FROM dbo.SiteOptions WITH (NOLOCK) WHERE Siteid=@siteid AND Section=@section AND Name=@name)
	BEGIN 
		-- Site specific setting. 
		SELECT @Value = Value
		  FROM dbo.SiteOptions WITH (NOLOCK)
		 WHERE Siteid = @siteid
		   AND Section = @section 
		   AND Name = @name
	END
	ELSE 
	BEGIN
		-- Default setting. 
		SELECT @Value = Value
		  FROM dbo.SiteOptions WITH (NOLOCK)
		 WHERE Siteid = 0 -- Default
		   AND Section = @section 
		   AND Name = @name
	END
	
	RETURN @Value
END