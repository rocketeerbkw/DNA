/*
	updatehierarchycounts

	Updates the NodeMembers and ArticleMembers fields of the hierarchy tree
	to reflect the correct count of nodes and articles in the given node.
	
	Updates the ThreadMembers and UsersMembers fields of the hierarchy tree
	to reflect the correct count of threads and Users in the given node.	
	
	This should be called when articles are catalogued and when new nodes are
	added to the categorisation hierarchy.
	
	The two counts calculated are used by the browse page. 

*/
Create Procedure updatehierarchycounts @nodeid int=0
As

IF @nodeid=0
BEGIN
	UPDATE hierarchy 
		Set NodeMembers = 
			(SELECT COUNT(*) 
				FROM Hierarchy h 
				WHERE h.parentid = hierarchy.nodeid
			), 
		ArticleMembers = 
			(SELECT COUNT(*) 
				FROM hierarchyarticlemembers c 
				WHERE c.nodeid = hierarchy.nodeid),
		ClubMembers = 
			(SELECT COUNT(*) 
				FROM hierarchyclubmembers c 
				WHERE c.nodeid = hierarchy.nodeid),
		NodeAliasMembers =
			(SELECT COUNT(*) 
				FROM hierarchynodealias c 
				WHERE c.nodeid = hierarchy.nodeid),
		ThreadMembers = 
			(SELECT COUNT(*) 
				FROM HierarchyThreadMembers AS ht 
				WHERE ht.nodeid = hierarchy.nodeid), 
		UserMembers = 
			(SELECT COUNT(*) 
				FROM HierarchyUserMembers AS hu 
				WHERE hu.nodeid = hierarchy.nodeid
			)
END	
ELSE
BEGIN
	UPDATE hierarchy 
		Set NodeMembers = 
			(SELECT COUNT(*) 
				FROM Hierarchy h 
				WHERE h.parentid = hierarchy.nodeid
			), 
		ArticleMembers = 
			(SELECT COUNT(*) 
				FROM hierarchyarticlemembers c 
				WHERE c.nodeid = hierarchy.nodeid),
		ClubMembers = 
			(SELECT COUNT(*) 
				FROM hierarchyclubmembers c 
				WHERE c.nodeid = hierarchy.nodeid),
		NodeAliasMembers =
			(SELECT COUNT(*) 
				FROM hierarchynodealias c 
				WHERE c.nodeid = hierarchy.nodeid),
		ThreadMembers = 
			(SELECT COUNT(*) 
				FROM HierarchyThreadMembers AS ht 
				WHERE ht.nodeid = hierarchy.nodeid), 
		UserMembers = 
			(SELECT COUNT(*) 
				FROM HierarchyUserMembers AS hu 
				WHERE hu.nodeid = hierarchy.nodeid
			)
	WHERE nodeid=@nodeid
END

RETURN @@ERROR
