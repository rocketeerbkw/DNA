Create Procedure getarticleforumarchivestatus @h2g2id int
as
select 'ArchiveStatus' = CASE WHEN f.CanWrite = 0 THEN 1 ELSE 0 END
FROM GuideEntries g INNER JOIN Forums f ON g.ForumID = f.ForumID
WHERE g.h2g2ID = @h2g2id