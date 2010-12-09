CREATE VIEW VCommentsRatingValue
WITH SCHEMABINDING
AS
SELECT     entryid, forumid, sum(value) AS value, count_big(*) as numberofratings
FROM         [dbo ].[ThreadEntryRating]
GROUP BY entryid,forumid                
GO
CREATE UNIQUE CLUSTERED INDEX IX_VCommentsRatingValue ON [dbo].[VCommentsRatingValue] 
(
	entryid
)
GO
CREATE INDEX IX_VCommentsRatingValue_Forumid ON [dbo].[VCommentsRatingValue] 
(
	forumid
)