CREATE PROCEDURE gettotalnumberofclubs @siteid INT
AS 
	/* Returns the total number of clubs created accross a site. */
	SELECT COUNT(*)
	  FROM dbo.Clubs WITH (NOLOCK)
	 WHERE SiteID = @siteid

RETURN @@ERROR
