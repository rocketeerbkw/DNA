CREATE PROCEDURE unblockusersubscription @authorid INT, @userid INT
AS
	DELETE FROM BlockedUserSubscriptions WHERE authorid = @authorid AND userid = @userid
	
	select UserID 
		,UserName
		,FirstNames
		,LastName
		,Status
		,Active
		,Postcode
		,Area
		,TaxonomyNode
		,UnreadPublicMessageCount
		,UnreadPrivateMessageCount
		,Region
		,HideLocation
		,HideUserName from users where userid = @userid
	
	RETURN @@ERROR