CREATE PROCEDURE getnumberofemailalertsubscribers @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns count of email alert customers. */
	SELECT COUNT(DISTINCT UserID)
	  FROM dbo.EMailAlertList WITH (NOLOCK)
	 WHERE SiteID = @siteid
	   AND CreatedDate BETWEEN @startdate AND @enddate

RETURN @@ERROR