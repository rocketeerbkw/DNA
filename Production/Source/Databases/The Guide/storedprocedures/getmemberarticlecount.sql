CREATE PROCEDURE getmemberarticlecount @userid INT, @siteid INT
AS 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Get article count for today
SELECT COUNT(*) 'articlecount'
FROM GuideEntries g 
WHERE g.editor = @userid AND g.siteid = @siteid AND DATEDIFF(day,g.DateCreated,GETDATE()) = 0
