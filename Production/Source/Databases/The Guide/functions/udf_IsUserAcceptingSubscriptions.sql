CREATE FUNCTION udf_isuseracceptingsubscriptions(@userid INT) 
RETURNS BIT
AS
BEGIN

	/*
		Function: Checks if user is accapting subscriptions.

		Params:
			@userid - user to check.

		Returns: 1 if true, 0 otherwise.
	*/

	IF EXISTS (SELECT 1 FROM dbo.Users WITH (NOLOCK) WHERE UserID = @userid AND AcceptSubscriptions = 1)
	BEGIN
		RETURN 1
	END

	RETURN 0
END
