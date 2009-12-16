CREATE PROCEDURE getexmoderationevents
AS

SELECT ex.ModId, uri, callbackuri, notes, status, datecompleted
FROM ExModEventQueue eq
INNER JOIN ExLinkMod ex ON ex.modid = eq.modid
WHERE ISNULL(RetryCount,0) = 0
UNION ALL
SELECT ex.ModId, uri, callbackuri, notes, status, datecompleted
FROM ExModEventQueue eq
INNER JOIN ExLinkMod ex ON ex.modid = eq.modid
WHERE ISNULL(RetryCount,0) > 0 AND DATEDIFF(hour, LastRetry, CURRENT_TIMESTAMP ) > RetryCount
