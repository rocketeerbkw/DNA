CREATE PROCEDURE getallnodesthatnoticeboardpostbelongsto @ithreadid INT
AS
BEGIN
	--There are 2 mechanisms here.
	-- A notice board post is attached to a node via the HierarchyThreadMembers table. 

	--Get Node that Notice Board post has been attached to.
	SELECT h.NodeID, h.Type, h.DisplayName, h.SiteID, h.NodeMembers 
	FROM [dbo].hierarchy AS h WITH(NOLOCK)
	INNER JOIN [dbo].hierarchythreadmembers hc WITH(NOLOCK) ON hc.NodeID = h.NodeID
	WHERE hc.ThreadId = @ithreadid

	--UNION 
	-- Get NoticeBoard / Location that Thread is attached to.
	--SELECT h.NodeID, h.Type, h.DisplayName, h.SiteID FROM [dbo].hierarchy h WITH(NOLOCK)
	--WHERE h.h2g2ID IN (
	--SELECT h2g2ID FROM [dbo].GuideEntries g WITH(NOLOCK)
	--INNER JOIN [dbo].Threads th WITH(NOLOCK) ON th.ForumID = g.ForumID AND th.ThreadId = @ithreadid
	--)

	DECLARE @ErrorCode INT
	IF ( @@ERROR <> 0 ) 
	BEGIN
		SET @ErrorCode = @@ERROR
		EXECUTE Error ErrorCode
		RETURN @ErrorCode
	END

	RETURN 0
		
END