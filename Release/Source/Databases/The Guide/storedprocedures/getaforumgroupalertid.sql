CREATE PROCEDURE getaforumgroupalertid @userid int, @siteid int, @forumid int
as
DECLARE @ItemType int
EXEC SetItemTypeValInternal 'IT_FORUM', @ItemType OUTPUT
SELECT GroupID
FROM dbo.AlertGroups
WHERE UserID = @userid AND SiteID = @siteid AND ItemType = @ItemType AND ItemID = @forumid