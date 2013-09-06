CREATE VIEW VCommentsRatingValue
WITH SCHEMABINDING
AS
SELECT
	entryid,
	forumid,
	sum(value) AS value,
	sum(case when value > 0 then value else 0 end) as positivevalue,
	sum(case when value < 0 then value else 0 end) as negativevalue,
	count_big(*) as numberofratings
FROM [dbo].[ThreadEntryRating]
GROUP BY entryid, forumid

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