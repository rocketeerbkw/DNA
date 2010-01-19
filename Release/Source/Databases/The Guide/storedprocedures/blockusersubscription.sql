CREATE PROCEDURE blockusersubscription @authorid INT, @userid INT
AS
	IF ( dbo.udf_isusersubscriptionblocked(@userid, @authorid) = 0 )
	BEGIN
		INSERT INTO BlockedUserSubscriptions ( authorId, userId ) 
		VALUES ( @authorid, @userid )
		
		--Cascading delete should also remove subscribed content.
		DELETE FROM UserSubscriptions WHERE authorid = @authorid AND userid = @userid
	END
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