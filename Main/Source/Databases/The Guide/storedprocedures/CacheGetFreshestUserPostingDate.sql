CREATE PROCEDURE cachegetfreshestuserpostingdate @userid int
AS

SELECT 'seconds' = MIN(tval)-1 FROM
(
SELECT 'tval' = DATEDIFF(second, DatePosted, getdate()) FROM ThreadEntries te WITH(NOLOCK) 
WHERE te.UserID = @userid
UNION
SELECT 'tval' = 60*60*24	-- don't cache longer than 24 hours
) t
