CREATE PROCEDURE getthreadgroupalertid @userid int, @siteid int, @threadid int
as
DECLARE @ItemType int
EXEC SetItemTypeValInternal 'IT_THREAD', @ItemType OUTPUT
SELECT GroupID
FROM dbo.AlertGroups
WHERE UserID = @userid AND SiteID = @siteid AND ItemType = @ItemType AND ItemID = @threadid
