CREATE PROCEDURE subscribetouser @userid INT, @authorid INT, @siteid INT
AS

	/*
		Function: Subsribes one user to another.

		Params:
			@userid - UserID of the user who wishes to subscribe.
			@authorid - UserID of the user who is being subscribed to. 
			@siteid - SiteID user is trying to subscribe to author on. 

		Returns: 0 on success, int on failure: 1 if author is not accepting subscriptions; 2 if user's subscription is blocked. 

		Throws: UserCantSubscribeToSelf (severity 16) if user is trying to subscribe to themselves.
				UserHasNotAcceptedTermsAndConditionsOfSite (severity 16) if user has not accepted T&Cs of site.
	*/

	IF (@userid=@authorid)
	BEGIN
		RAISERROR ('User can''t subscribe to themselves.', 16, 1);
		RETURN @@ERROR
	END 

	IF(dbo.udf_hasuseracceptedtermsandconditionsofsite(@userid, @siteid) = 0)
	BEGIN
		RAISERROR ('User has not accepted terms and conditions for site.', 16, 1);
		RETURN @@ERROR
	END

	IF (dbo.udf_isuseracceptingsubscriptions(@authorid) = 0)
	BEGIN
		RETURN 1; 
	END 

	IF (dbo.udf_isusersubscriptionblocked(@userid, @authorid) = 1)
	BEGIN
		RETURN 2;
	END
	
	IF NOT EXISTS (SELECT 1 FROM dbo.UserSubscriptions WHERE UserID = @userid AND AuthorID = @authorid)
	BEGIN
		INSERT INTO dbo.UserSubscriptions (UserID, AuthorID) VALUES (@userid, @authorid);
		DECLARE @ErrorCode int
		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc = 'subscribetouser',
												  @siteid = @siteid,
												  @userid = @authorid
		IF (@ErrorCode <> 0 ) RETURN @ErrorCode;												  
		
	END
	
	select userid, username from users where userid = @authorid

RETURN 0;