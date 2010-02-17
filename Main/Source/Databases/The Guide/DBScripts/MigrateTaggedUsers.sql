/*
-- Show how many users are currently incorrectly tagged
SELECT * from hierarchyarticlemembers ham WITH(NOLOCK)
INNER JOIN Users u WITH(NOLOCK) on u.masthead = ham.h2g2id
INNER JOIN Hierarchy h WITH(NOLOCK) on h.nodeid = ham.nodeid
WHERE h.siteid = 16
*/
DECLARE @SiteID int
SELECT @SiteID = SiteID FROM Sites WITH(NOLOCK) WHERE URLName like 'ActionNetwork'

BEGIN TRANSACTION

-- First move all the users who arn't already in the User members table
INSERT INTO HierarchyUserMembers SELECT UserID = un.UserID, NodeID = un.NodeID
FROM
(
	SELECT DISTINCT ham.nodeid,u.userid FROM HierarchyArticleMembers ham WITH(NOLOCK)
	INNER JOIN Users u WITH(NOLOCK) on u.masthead = ham.h2g2id
	INNER JOIN Hierarchy h WITH(NOLOCK) on h.nodeid = ham.nodeid
	LEFT OUTER JOIN
	(
		SELECT u.userid, hum.nodeid FROM HierarchyUserMembers hum WITH(NOLOCK)
		INNER JOIN Users u WITH(NOLOCK) on u.userid = hum.userid
		INNER JOIN Hierarchy h WITH(NOLOCK) on h.nodeid = hum.NodeID
		WHERE h.siteid = @SiteID
	) AS already ON already.userid = u.userid AND already.nodeid = ham.nodeid
	WHERE already.userid IS NULL AND h.siteid = @SiteID
) AS un
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

-- Now remove the users we've just moved
DELETE HierarchyArticleMembers FROM
(
	SELECT ham.nodeid, ham.h2g2id from hierarchyarticlemembers ham WITH(NOLOCK)
	INNER JOIN Users u WITH(NOLOCK) on u.masthead = ham.h2g2id
	INNER JOIN Hierarchy h WITH(NOLOCK) on h.NodeId = ham.NodeID
	WHERE h.siteid = @SiteID
) AS un
WHERE hierarchyarticlemembers.nodeid = un.nodeid AND hierarchyarticlemembers.h2g2id = un.h2g2id
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

COMMIT TRANSACTION