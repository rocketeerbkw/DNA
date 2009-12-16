CREATE PROCEDURE getclubgroupalertid @userid int, @siteid int, @clubid int
as
DECLARE @ItemType int
EXEC SetItemTypeValInternal 'IT_CLUB', @ItemType OUTPUT
SELECT GroupID
FROM dbo.AlertGroups
WHERE UserID = @userid AND SiteID = @siteid AND ItemType = @ItemType AND ItemID = @clubid