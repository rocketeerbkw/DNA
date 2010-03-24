CREATE PROCEDURE getuserhierarchynodes @userid int, @siteid int
AS

SELECT Nodeid, Type, DisplayName, NodeMembers FROM hierarchy h WITH(NOLOCK) WHERE h.nodeid IN
(
	-- Get all the nodes the user's articles are attached to on this site
	SELECT nodeid FROM hierarchyarticlemembers ham WITH(NOLOCK)
		INNER JOIN guideentries g WITH(NOLOCK) ON g.EntryID = ham.EntryID
		WHERE g.hidden IS NULL AND g.editor = @userid AND g.siteid = @siteid
	-- Now union all the nodes the user's clubs are attached to on this site	
	UNION
	SELECT nodeid FROM hierarchyclubmembers hcm WITH(NOLOCK)
		WHERE hcm.clubid IN
		(
			SELECT clubid FROM clubs c WITH(NOLOCK)
				INNER JOIN guideentries g WITH(NOLOCK,INDEX=IX_h2g2ID) ON g.h2g2id=c.h2g2id
				INNER JOIN teammembers t WITH(NOLOCK) ON t.teamid = c.memberteam AND t.userid = @userid
				WHERE g.hidden IS NULL AND c.siteid=@siteid 
		)
	UNION
	
	Select nodeid FROM hierarchythreadmembers hfm 
	INNER JOIN ThreadEntries th ON hfm.ThreadId = th.ThreadId AND th.UserID = @UserId AND PostIndex = 0
		
	UNION
	
	Select NodeId FROM hierarchyusermembers hum
	INNER JOIN Users u ON u.UserId = hum.UserId AND hum.UserId = @userId
)
ORDER BY h.type, h.treelevel