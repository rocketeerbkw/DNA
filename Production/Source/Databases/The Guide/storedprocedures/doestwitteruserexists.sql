/* doestwitteruserexists

Checks if the twitter user to be associated with the twitter profile creation
already exists in DNA. If exists, return the TwitterUserID else return 'NA'
which is handled appropriately in the middle layer

*/

CREATE procedure doestwitteruserexists @twitterscreenname  nvarchar(max)
AS
BEGIN
	
	SELECT UserID, TwitterUserID
	FROM Users u
	INNER JOIN SignInUserIDMapping sm ON u.userid=sm.DnaUserId
	WHERE u.LoginName = @twitterscreenname AND sm.TwitterUserId IS NOT NULL
	
END