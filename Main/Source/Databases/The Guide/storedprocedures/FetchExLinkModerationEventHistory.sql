create procedure fetchexlinkmoderationeventhistory @url varchar(256)
AS

SELECT ex.*, m.uri,m.callbackuri 
FROM ExLinkModHistory ex
INNER JOIN ExLinkMod m ON m.modid = ex.modid
WHERE m.uri = @url
ORDER BY ModId , Timestamp
