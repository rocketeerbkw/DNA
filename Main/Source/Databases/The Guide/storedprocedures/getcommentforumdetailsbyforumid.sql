
CREATE PROCEDURE getcommentforumdetailsbyforumid 
	@forumid int
AS

SELECT 
	CF.Url AS URL
	,  F.Title AS TITLE
FROM CommentForums CF
INNER JOIN Forums F on CF.ForumID = F.ForumID
where CF.ForumID = @forumid
