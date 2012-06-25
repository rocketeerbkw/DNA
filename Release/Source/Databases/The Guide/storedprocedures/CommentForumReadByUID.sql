CREATE PROCEDURE commentforumreadbyuid @uid varchar(255), @siteurlname varchar(30)
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT
		uid,
		sitename,
		title,
		forumpostcount,
		moderationstatus,
		datecreated,
		lastupdated,
		url,
		ISNULL(forumclosedate, GETDATE()) AS forumclosedate,
		0 AS totalresults,
		0 AS startindex,
		0 AS itemsperpage,
		siteId,
		forumId,
		canRead,
		canWrite,
		lastposted,
		editorpickcount,
		NotSignedInUserId,
		IsContactForm
	FROM 
		dbo.VCommentForums 
	WHERE
		uid = @uid AND sitename = @siteurlname

