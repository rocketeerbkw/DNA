CREATE PROCEDURE cachegettimeofmostrecentguideentry
AS
SELECT 'seconds' = MIN(tval)-1 FROM
(
SELECT 'tval' = DATEDIFF(second, MAX(DateCreated), getdate()) FROM GuideEntries WHERE DateCreated <= getdate() AND status = 1
UNION
SELECT 'tval' = 60*60*24 --don't cache longer than 24 hours
) t




--SELECT 'seconds' = MIN(tval)-1 FROM
--(
--SELECT 'tval' = DATEDIFF(second, MAX(DateCreated), getdate()) FROM GuideEntries g WHERE g.h2g2id = @h2g2id
--UNION
--SELECT 'tval' = 60*60*24	-- don't cache longer than 24 hours
--) t