CREATE PROCEDURE getmostrecentforumpost @h2g2id int
 AS
	DECLARE @sincepost int, @sinceupdate int, @entryid int
	SELECT @entryid = @h2g2id / 10
SELECT 'seconds' = MIN(tval) FROM
(
SELECT 'tval' = DATEDIFF(second, MAX(DatePerformed), getdate()) FROM EditHistory WHERE EntryID = @entryid
UNION
SELECT 'tval' = DATEDIFF(second,  MAX(DatePosted), getdate()) FROM ThreadEntries t, GuideEntries g WHERE t.ForumID = g.ForumID AND g.h2g2ID = @h2g2id
UNION
SELECT 'tval' = DATEDIFF(second, DateCreated, getdate()) FROM GuideEntries g WHERE g.h2g2id = @h2g2id
) t
