CREATE PROCEDURE gethierarchyclosenodes @nodeid INT, @baseline INT
AS

IF @baseline >= 100
BEGIN	--children only
	SELECT 
		'child' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		hierarchy h WITH(NOLOCK)
	WHERE 
		parentid = @nodeid AND (ClubMembers > 0 OR ArticleMembers > 0)
END
ELSE	--children, parent, indirect parents, baseline, indirect parents baseline
BEGIN
	SELECT 
		'parent' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		hierarchy h WITH(NOLOCK), hierarchy h1 WITH(NOLOCK)
	WHERE 
		h.NodeId = h1.parentid AND h1.NodeId = @nodeid AND
		(h.ClubMembers > 0 OR h.ArticleMembers > 0)
		
	UNION

	SELECT 
		'child' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		hierarchy h WITH(NOLOCK)
	WHERE 
		parentid = @nodeid AND (ClubMembers > 0 OR ArticleMembers > 0)
		
	UNION

	SELECT 
		'baseline' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		ancestors a WITH(NOLOCK), hierarchy h  WITH(NOLOCK)
	WHERE 
		a.NodeId = @nodeid AND h.baseline = 100 AND a.ancestorid = h.NodeId
		AND (h.ClubMembers > 0 OR h.ArticleMembers > 0)
		
	UNION

	--indirect parent
	SELECT 
		'iparent' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		hierarchy h WITH(NOLOCK), hierarchynodealias hna  WITH(NOLOCK)
	WHERE 
		h.NodeId = hna.NodeId AND hna.LinkNodeId = @nodeid
		AND (ClubMembers > 0 OR ArticleMembers > 0)

	UNION
			
	--indirect parent baseline
	SELECT 
		'ibaseline' NodePos, h.NodeId, h.DisplayName, h.Description, h.ParentID, 
		h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID
	FROM 
		hierarchy h WITH(NOLOCK), hierarchynodealias hna WITH(NOLOCK), ancestors a WITH(NOLOCK), hierarchy h1 WITH(NOLOCK) 
	WHERE 
		h1.NodeId = hna.NodeId AND hna.LinkNodeId = @nodeid
		AND (h.ClubMembers > 0 OR h.ArticleMembers > 0) AND a.NodeId = h1.NodeId 
		AND a.AncestorId = h.NodeId	AND h.baseline = 100;
		
END		

RETURN (0) 
