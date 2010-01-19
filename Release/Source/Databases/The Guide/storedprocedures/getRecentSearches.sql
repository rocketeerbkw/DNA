CREATE PROCEDURE getrecentsearches @siteid int
As

SELECT searchid, term, stamp, searchtype 'type', [count] 'count'
FROM [dbo].recentsearch 
WHERE siteid = @siteid 
ORDER BY stamp DESC
