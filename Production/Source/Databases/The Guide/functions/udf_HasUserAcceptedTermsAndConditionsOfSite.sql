CREATE FUNCTION udf_hasuseracceptedtermsandconditionsofsite(@userid INT, @siteid INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN

	/*
		Function: Checks if user has accepted terms and conditions of site.

		Params:
			@userid - user to check.
			@siteid - site to check against. 

		Returns: 1 if true, 0 otherwise.
	*/

	IF EXISTS (SELECT 1 FROM dbo.Mastheads WITH (NOLOCK) WHERE UserID = @userid AND SiteID = @siteid)
	BEGIN
		RETURN 1
	END

	RETURN 0
END