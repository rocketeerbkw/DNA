CREATE Procedure addarticlesubscription @h2g2id INT
AS
	--Duplicates will cause a unique constraint violation.
	INSERT INTO ArticleSubscriptions ( userid, authorid, entryid, datecreated, siteid )
	SELECT u.userId, g.editor, g.EntryId, g.DateCreated, g.SiteId
	FROM GuideEntries g
	INNER JOIN UserSubscriptions u ON u.authorId = g.editor
	WHERE g.h2g2Id = @h2g2id

RETURN @@ERROR