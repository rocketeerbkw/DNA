/*	
	Fetches the number of queued moderation items and complains for each site
	for given users
*/

CREATE PROCEDURE getqueuedmodpersite @userid INT
AS

DECLARE @ModGroupId INT
SELECT @ModGroupId = groupID FROM Groups WITH(NOLOCK) WHERE NAME = 'Moderator'

DECLARE @RefGroupId INT
SELECT @RefGroupId = groupID FROM Groups WITH(NOLOCK) WHERE NAME = 'Referee'

SELECT s.siteID, s.ShortName, s.URLName, a.Complaint, 
	CASE 
		WHEN EXISTS (SELECT siteid FROM groupmembers gm WITH(NOLOCK) 
						WHERE gm.siteid = s.siteid AND gm.userid = @userid 
								AND gm.groupid = @modgroupid) 
			THEN 1 
		ELSE 0 
	END Moderator,
	CASE 
		WHEN EXISTS (SELECT siteid FROM groupmembers gm 
						WHERE gm.siteid = s.siteid AND gm.userid = @userid 
						AND gm.groupid = @RefGroupId) 
			THEN 1 
		ELSE 0 
	END Referee,
	SUM(a.Total) Total, Status
FROM 
(
	SELECT tm.siteid siteid, 
			(CASE 
				WHEN tm.complainantID IS NULL THEN 0 
				ELSE 1 
			END) Complaint, 
			count(*) Total,	tm.status Status
		FROM threadmod tm WITH(NOLOCK)
		WHERE ((tm.status = 0) 
				OR (tm.status = 2 AND (tm.lockedby IS NULL OR tm.lockedby = @userid))) 
				AND tm.newpost = 1
		GROUP BY tm.siteid, 
				(CASE 
					WHEN tm.complainantID IS NULL THEN 0 
					ELSE 1 
				END),
				tm.Status
	UNION ALL
	SELECT am.siteid siteid, 
			(CASE 
				WHEN am.complainantID IS NULL THEN 0 
				ELSE 1 
			END) Complaint, 
			count(*) Total,
			am.Status Status
		FROM ArticleMod am WITH(NOLOCK)
		WHERE ((am.status = 0) 
				OR (am.status = 2 AND (am.lockedby IS NULL OR am.lockedby = @userid)))
				AND am.newArticle = 1
		GROUP BY am.siteid, 
				(CASE 
					WHEN am.complainantID IS NULL THEN 0 
					ELSE 1 
				END),
				am.Status
	UNION ALL
	SELECT ex.siteid siteid, 
			(CASE 
				WHEN ex.complainttext IS NULL THEN 0 
				ELSE 1 
			END) Complaint, 
			count(*) Total,	ex.status Status
		FROM exlinkmod ex WITH(NOLOCK)
		WHERE (( ex.status = 0 ) OR ( ex.status = 2 AND ( ISNULL(ex.lockedby,@userid) = @userid ))) 
		GROUP BY ex.siteid, 
				(CASE WHEN ex.complainttext IS NULL THEN 0 ELSE 1 END),
				ex.Status
	UNION ALL
	SELECT gm.siteid siteid, 1 Complaint, count(*) Total, gm.Status Status
		FROM GeneralMod gm WITH(NOLOCK)
		WHERE ((gm.status = 0) 
				OR (gm.status = 2 AND (gm.lockedby IS NULL OR gm.lockedby = @userid)))
		GROUP BY gm.siteid, gm.Status
) a INNER JOIN Sites s WITH(NOLOCK) ON a.siteid = s.siteid
GROUP BY s.siteid, s.ShortName, s.URLName, a.Complaint, a.Status
ORDER BY s.siteid