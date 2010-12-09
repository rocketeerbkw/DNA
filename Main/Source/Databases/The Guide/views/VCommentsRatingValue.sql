CREATE VIEW VCommentsRatingValue
WITH SCHEMABINDING
AS
SELECT     entryid, forumid, sum(value) AS value, count_big(*) as numberofratings
FROM         [dbo ].[ThreadEntryRating]
GROUP BY entryid,forumid 
                    
