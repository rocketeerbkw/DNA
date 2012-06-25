--Hack day SP needs some tweekings and shoule be integrated 

CREATE PROCEDURE getnewssitestats
AS
BEGIN
	SELECT 
	COUNT(te.entryid) AS TotalCommentCount, 
	RCT.RatedCommentCount,
	RCT.TotalRatingValue, 
	RCT.avgRating, 
	cf.forumid 
	FROM CommentForums cf 
	INNER JOIN forums f ON cf.forumid = f.forumid
	INNER JOIN ThreadEntries te ON f.forumid = te.forumid 
	INNER JOIN 
	(SELECT COUNT(entryid) AS RatedCommentCount, 
	SUM(value) AS TotalRatingValue,
	(SUM(CAST (value AS FLOAT))/COUNT(entryid)) AS avgRating, 
	forumid FROM ThreadEntryRating
	GROUP BY forumid) AS RCT
	ON cf.forumid = RCT.forumid
	WHERE f.SiteID = 492
	GROUP BY cf.forumid, RCT.RatedCommentCount, RCT.TotalRatingValue, RCT.avgRating

END
