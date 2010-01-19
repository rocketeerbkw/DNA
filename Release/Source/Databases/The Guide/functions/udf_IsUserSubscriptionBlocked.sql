CREATE FUNCTION udf_isusersubscriptionblocked(@userid INT, @authorid INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN

	/*
		Function: Checks if user is blocked from subscribing to author.

		Params:
			@userid - user who wishes to subscribe.
			@authorid - user who is being subscribed to. 

		Returns: 1 if blocked, 0 otherwise.
	*/

	IF EXISTS (SELECT 1 FROM dbo.BlockedUserSubscriptions WITH (NOLOCK) WHERE UserID = @userid AND AuthorID = @authorid)
	BEGIN
		RETURN 1
	END

	RETURN 0
END
