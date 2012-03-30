/* doestwitteruserexists

Checks if the twitter user to be associated with the twitter profile creation
already exists in DNA. If exists, return the TwitterUserID else return 'NA'
which is handled appropriately in the middle layer

*/

CREATE procedure doestwitteruserexists @twitterscreenname  nvarchar(max)
AS
BEGIN
	-- check to see if the twitteruser exists in DNA
	DECLARE @DNAUSERID INT, @TwitterUserID nvarchar(40)

	--SELECT @DNAUSERID = UserID FROM Users WHERE LoginName = @twitterscreenname AND EncryptedEmail IS NULL
	
	SELECT @DNAUSERID = UserID, @TwitterUserID=TwitterUserID
	FROM Users u
	INNER JOIN SignInUserIDMapping sm ON u.userid=sm.DnaUserId
	WHERE u.LoginName = @twitterscreenname AND sm.TwitterUserId IS NOT NULL
	
	IF (@DNAUSERID IS NOT NULL)
	BEGIN
		SELECT @TwitterUserID AS TwitterUserID
	END
	ELSE
	BEGIN
		SELECT 'NA' AS TwitterUserID
	END
	
END