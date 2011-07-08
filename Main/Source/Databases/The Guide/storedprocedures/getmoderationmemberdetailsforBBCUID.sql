CREATE PROCEDURE getmoderationmemberdetailsforbbcuid @viewinguserid INT, @usertofindid INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

EXEC openemailaddresskey

DECLARE @EditorGroupID INT
SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor'

DECLARE @issuperuser INT
SELECT @issuperuser = CASE WHEN Status = 2 THEN 1 ELSE 0 END FROM Users WHERE userid = @viewinguserid

-- Get cookis associated with user
DECLARE @bbcuids AS TABLE( BBCUID UNIQUEIDENTIFIER )
INSERT INTO @bbcuids 
SELECT DISTINCT BBCUID
FROM ThreadEntriesIPAddress teip
INNER JOIN ThreadEntries te ON te.EntryId = teip.EntryId
WHERE te.userid = @usertofindid AND teip.BBCUID IS NOT NULL AND teip.BBCUID != '00000000-0000-0000-0000-000000000000'

-- Get users that have been associated with cokkies above.
DECLARE @userids AS TABLE ( userid INT )
INSERT INTO @userids 
SELECT DISTINCT 
te.userid
FROM ThreadEntriesIPAddress teip
INNER JOIN @bbcuids bbc ON bbc.BBCUID = teip.BBCUID
INNER JOIN ThreadEntries te ON te.EntryId = teip.EntryId

-- Create a look-up table containing the number of posts for these users per site
-- This is much more efficient than the plan it was coming up with when it was
-- doing this work by joining on a subquery
DECLARE @UserNumPostsPerSite AS TABLE (userid int, siteid int, numposts int)
INSERT @UserNumPostsPerSite
	SELECT u.userid,f.siteid,count(*)
		FROM @userids u 
		INNER JOIN Preferences p ON p.UserId = u.UserId
		INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
		INNER JOIN ThreadEntries te ON te.userid = u.userid
		INNER JOIN Forums f ON f.forumid=te.forumid AND f.siteid=p.siteid
		GROUP BY u.userid,f.SiteId

-- Get Moderation stats for the relevant users.
SELECT DISTINCT 
u.userid, 
u.username, 
u.loginname, 
dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) as Email,
u.Active, 
p.PrefStatus, 
p.PrefStatusChangedDate, 
p.DateJoined, 
s.SiteId, 
s.ShortName, 
s.urlname,
passed.count 'postpassedcount',
failed.count 'postfailedcount',
(select numposts from @UserNumPostsPerSite unpps where unpps.userid=u.userid and unpps.siteid=s.siteid) totalpostcount,
articlepassed.count 'articlepassedcount',
articlefailed.count 'articlefailedcount',
totalarticle.count 'totalarticlecount'
FROM @userids users
INNER JOIN Users u ON u.UserId = users.userid
INNER JOIN Preferences p ON p.UserId = u.UserId
INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
LEFT JOIN  GroupMembers g WITH(NOLOCK) ON g.UserID = @Viewinguserid AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
LEFT JOIN ( SELECT te.userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
			INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
			INNER JOIN @userids u ON u.userid = te.userid
			WHERE tm.Status = 3 GROUP BY te.userId, siteId) AS passed ON passed.userId = u.userId AND passed.siteid = s.siteid
LEFT JOIN ( SELECT te.userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
			INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
			INNER JOIN @userids u ON u.userid = te.userid
			WHERE tm.Status = 4 GROUP BY te.userId, siteId) AS failed ON failed.userId = u.userId AND failed.siteid = s.siteid
LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
			INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
			INNER JOIN @userids u ON u.userid = ge.editor
			WHERE ge.type <= 1000 AND am.Status = 3 GROUP BY editor, am.siteId) AS articlepassed ON articlepassed.editor = u.userId AND articlepassed.siteid = s.siteid
LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
			INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
			INNER JOIN @userids u ON u.userid = ge.editor
			WHERE ge.type <= 1000 AND am.Status = 4 GROUP BY editor, am.siteId) AS articlefailed ON articlefailed.editor = u.userId AND articlefailed.siteid = s.siteid
LEFT JOIN ( SELECT editor, ge.siteId, COUNT(ge.h2g2Id) 'count' FROM GuideEntries ge
            INNER JOIN @userids u ON u.userid = ge.editor
			WHERE ge.type <= 1000 GROUP BY editor, ge.siteId) AS totalarticle ON totalarticle.editor = u.userId AND totalarticle.siteid = s.siteid
WHERE g.GroupID = @EditorGroupID OR @issuperuser = 1


/*
-- Performs much worse even though it is much the same query.
SELECT DISTINCT 
u.userid, 
u.username, 
u.loginname, 
u.Email, 
u.Active, 
p.PrefStatus, 
p.PrefStatusChangedDate, 
p.DateJoined, 
s.SiteId, 
s.ShortName, 
s.urlname
FROM @userids users
INNER JOIN Users u ON u.UserId = users.userid
INNER JOIN Preferences p ON p.UserId = u.UserId
INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
LEFT JOIN  GroupMembers g WITH(NOLOCK) ON g.UserID = @Viewinguserid AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
LEFT JOIN ( SELECT userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
			INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
			WHERE tm.Status = 3 AND te.userid = @usertofindid GROUP BY userId, siteId) AS passed ON passed.userId = u.userId AND passed.siteid = s.siteid
LEFT JOIN ( SELECT userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
			INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
			 WHERE tm.Status = 4 AND te.userid = @usertofindid GROUP BY userId, siteId) AS failed ON failed.userId = u.userId AND failed.siteid = s.siteid
LEFT JOIN ( SELECT userId, f.siteId, COUNT(te.EntryId) 'count' FROM ThreadEntries te
			INNER JOIN Forums f ON f.forumid = te.forumid
			 WHERE te.userid = @usertofindid GROUP BY userId, siteId) AS totalposts ON totalposts.userId = u.userId AND totalposts.siteid = s.siteid
LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
			INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
			 WHERE am.Status = 3 AND ge.editor = @usertofindid GROUP BY editor, am.siteId) AS articlepassed ON articlepassed.editor = u.userId AND articlepassed.siteid = s.siteid
LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
			INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
			 WHERE am.Status = 4 AND ge.editor = @usertofindid GROUP BY editor, am.siteId) AS articlefailed ON articlefailed.editor = u.userId AND articlefailed.siteid = s.siteid
LEFT JOIN ( SELECT editor, ge.siteId, COUNT(ge.h2g2Id) 'count' FROM GuideEntries ge
			 WHERE ge.editor = @usertofindid GROUP BY editor, ge.siteId) AS totalarticle ON totalarticle.editor = u.userId AND totalarticle.siteid = s.siteid
WHERE te.userid = @usertofindid AND (g.GroupID = @EditorGroupID OR @issuperuser = 1)*/

