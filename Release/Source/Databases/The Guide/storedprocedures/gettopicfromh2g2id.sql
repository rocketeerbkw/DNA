CREATE PROCEDURE gettopicfromh2g2id @h2g2id int
AS
SELECT TopicID, h2g2ID, SiteID, TopicStatus, TopicLinkID, EditKey, BoardPromoID, DefaultBoardPromoID FROM dbo.Topics WHERE h2g2ID = @h2g2id