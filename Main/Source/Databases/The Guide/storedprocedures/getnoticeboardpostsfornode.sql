CREATE PROCEDURE getnoticeboardpostsfornode @nodeid INT, @siteid INT
AS

-- Get the Details of the Notice and a count of the number of replies ( ThreadEntries) 
--for each Notice ( Thread )

DECLARE @ErrorCode INT

SELECT 	th.ThreadId, 
		th.ForumID, 
		th.Type,
		th.EventDate,
		te.Hidden,
		te.PostStyle,
		te.PostIndex,
		te.EntryID,
		te.Subject, 
		te.[Text], 
		te.LastUpdated, 
		te.DatePosted,
		u.UserID, 
		u.UserName, 
		u.FirstNames, 
		u.LastName, 
		u.Area,
		u.Status,
		u.TaxonomyNode,
		'Journal' = J.ForumID,
		u.Active,
		u.Postcode,
		p.SiteSuffix,
		p.Title,
		th.ThreadPostCount,
		hh.DisplayName
FROM Threads th WITH(NOLOCK) 
INNER JOIN [dbo].HierarchyThreadMembers h WITH(NOLOCK) ON h.ThreadId = th.ThreadId
INNER JOIN [dbo].Hierarchy hh WITH(NOLOCK) ON hh.NodeId = h.NodeId AND hh.SiteId = @siteid
INNER JOIN [dbo].ThreadEntries te WITH(NOLOCK) ON te.ThreadId = th.ThreadID
INNER JOIN [dbo].Users u WITH(NOLOCK) on te.UserID = u.UserID
LEFT  JOIN [dbo].Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = @siteid
INNER JOIN dbo.Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @siteid
WHERE h.NodeId = @nodeid 
AND te.PostIndex = 0 
AND (te.Hidden IS NULL OR te.Hidden = 0)

SET @ErrorCode = @@ERROR

RETURN @ErrorCode