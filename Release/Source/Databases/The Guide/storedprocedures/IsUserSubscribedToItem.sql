CREATE PROCEDURE isusersubscribedtoitem @userid int, @itemtype int, @itemid int
AS
SELECT il.* FROM ItemList il WITH(NOLOCK)
INNER JOIN ItemListMembers ilm WITH(NOLOCK) ON il.ItemListID = ilm.ItemListID
WHERE ilm.ItemType = @itemtype AND ilm.ItemID = @itemid AND il.UserID = @userid