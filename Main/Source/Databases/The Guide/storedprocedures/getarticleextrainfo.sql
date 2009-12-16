CREATE     PROCEDURE getarticleextrainfo @h2g2id int
AS
SELECT g.ExtraInfo, g.Type FROM GuideEntries g WHERE g.h2g2ID  = @h2g2id
