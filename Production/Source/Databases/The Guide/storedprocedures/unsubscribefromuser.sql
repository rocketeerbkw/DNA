/*********************************************************************************

	CREATE PROCEDURE unsubscribefromuser @userid int, @subscribedto int

	Author:		Steven Francis
	Created:	07/09/2007
	Inputs:		UserID of the subscriber 
				subscribedToID(UserID) of the subscribedTo person the user is unsubscribing from
	Outputs:	
	Purpose:	Removes the subscription to the given AuthorID.
				There are a number of cascading FK triggers to remove subscribeTo data
	
*********************************************************************************/

CREATE PROCEDURE unsubscribefromuser @userid int, @subscribedtoid int
AS
DELETE FROM UserSubscriptions WHERE UserID = @userid AND AuthorID = @subscribedtoid
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
		,HideUserName from users where UserID = @subscribedtoid
