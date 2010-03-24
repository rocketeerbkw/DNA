CREATE PROCEDURE getarticlegroupalertid @userid int, @siteid int, @h2g2id int
as
DECLARE @ItemType int
EXEC SetItemTypeValInternal 'IT_H2G2', @ItemType OUTPUT
SELECT GroupID
FROM dbo.AlertGroups
WHERE UserID = @userid AND SiteID = @siteid AND ItemType = @ItemType AND ItemID = @h2g2id