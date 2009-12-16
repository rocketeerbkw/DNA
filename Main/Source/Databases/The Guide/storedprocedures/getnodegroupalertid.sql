CREATE PROCEDURE getnodegroupalertid @userid int, @siteid int, @nodeid int
as
DECLARE @ItemType int
EXEC SetItemTypeValInternal 'IT_NODE', @ItemType OUTPUT
SELECT GroupID
FROM dbo.AlertGroups
WHERE UserID = @userid AND SiteID = @siteid AND ItemType = @ItemType AND ItemID = @nodeid