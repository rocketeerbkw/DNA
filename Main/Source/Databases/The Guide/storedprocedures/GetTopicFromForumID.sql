CREATE PROCEDURE gettopicfromforumid @forumid int
AS
SELECT t.TopicID, t.h2g2ID, t.SiteID, t.TopicStatus, t.TopicLinkID, t.EditKey, t.BoardPromoID, t.DefaultBoardPromoID FROM dbo.Topics t
INNER JOIN dbo.GuideEntries g ON g.h2g2id = t.h2g2id
WHERE g.ForumID = @forumid
