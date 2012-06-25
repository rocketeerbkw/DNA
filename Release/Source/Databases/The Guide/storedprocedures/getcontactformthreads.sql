CREATE PROCEDURE getcontactformthreads @forumid int
AS
SELECT
	*
FROM
	dbo.ContactForms
	INNER JOIN dbo.VCommentForums on dbo.VCommentForums.forumId = dbo.ContactForms.ForumID
WHERE
	dbo.ContactForms.ForumID = @forumid