CREATE PROCEDURE isusersubscribedtoalertgroup @itemid int, @itemtype int, @userid int
AS
-- Check to see if the user is subscribed to the group
IF EXISTS ( SELECT * FROM dbo.AlertGroups WITH(NOLOCK) WHERE UserID = @UserID AND ItemType = @ItemType AND ItemID = @ItemID )
BEGIN
	SELECT 'IsSubscrided' = 1, ealm.NotifyType, 'AlertType' = CASE WHEN eal.EmailAlertListID IS NULL THEN 2 ELSE 1 END
	FROM dbo.AlertGroups ag WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertListMembers ealm WITH(NOLOCK) ON ealm.AlertGroupID = ag.GroupID
	LEFT JOIN dbo.EmailAlertList eal WITH(NOLOCK) ON eal.EMailAlertlistID = ealm.EmailAlertListID
	WHERE ag.ItemID = @ItemID AND ag.ItemType = @ItemType AND ag.UserID = @UserID
END
ELSE
BEGIN
	SELECT 'IsSubscrided' = 0
END
