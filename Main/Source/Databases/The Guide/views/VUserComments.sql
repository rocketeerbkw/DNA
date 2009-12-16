CREATE VIEW VUserComments WITH SCHEMABINDING
AS
	SELECT te.userid, te.entryid, te.DatePosted, cf.siteid, cf.uid
		FROM dbo.threadentries te
		INNER JOIN dbo.commentforums cf ON cf.forumid=te.forumid
GO

CREATE UNIQUE CLUSTERED INDEX IX_VUserComments ON VUserComments
(
	userid ASC,
	entryid ASC,
	siteid ASC
)

GO

CREATE INDEX IX_VUserComments_DatePosted ON VUserComments
(
	DatePosted DESC,
	uid ASC
)
GO
