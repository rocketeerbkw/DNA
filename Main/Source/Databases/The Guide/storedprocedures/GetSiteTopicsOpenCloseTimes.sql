CREATE PROCEDURE getsitetopicsopenclosetimes --@siteid INT 
AS
	/* 
		Returns site's open and close times. Must be in this order to iteration through collection
		in Ripley picks up the last event correctly. I.e. if an open and close event occur at the 
		same time the closed event is picked up first. 
	*/
	SELECT SiteID, DayWeek, Hour, Minute, Closed
	  FROM dbo.SiteTopicsOpenCloseTimes WITH(NOLOCK)
	 --WHERE SiteID = @siteid
	 ORDER BY SiteID, DayWeek DESC, Hour DESC, Minute DESC, Closed DESC 
	 

RETURN @@ERROR