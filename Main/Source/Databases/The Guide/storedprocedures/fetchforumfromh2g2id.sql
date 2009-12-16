CREATE PROCEDURE fetchforumfromh2g2id @h2g2id int
AS
SELECT g.ForumID
FROM GuideEntries g
WHERE g.H2G2ID = @h2g2id