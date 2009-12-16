CREATE PROCEDURE getmoderationmemberdetails @viewinguserid int, @usertofindid int
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Get the Editor group id from the groups table
	DECLARE @EditorGroupID INT
	SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor'

	DECLARE @email VARCHAR(255)
	DECLARE @issuperuser INT
	SELECT @issuperuser = CASE WHEN Status = 2 THEN 1 ELSE 0 END FROM Users WHERE userid = @viewinguserid
	SELECT @email = email FROM users WHERE userid = @usertofindid
	
	IF (@Email != '' AND @Email IS NOT NULL AND @Email != '0')
	BEGIN
	
	    DECLARE @userids AS TABLE ( userid INT )
	    INSERT INTO @userids( userid )
	    SELECT uu.userid
	    FROM Users uu
	    WHERE  uu.email =  @Email AND uu.Email LIKE '%@%'
	    
		-- Get all the user entries for the given email fo sites that the viewing user is an Editor
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				u.Email,
				u.Active,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.DateJoined,
				p.SiteID,
				s.ShortName,
				s.urlname,
				passed.count 'postpassedcount',
				failed.count 'postfailedcount',
				totalposts.count 'totalpostcount',
				articlepassed.count 'articlepassedcount',
				articlefailed.count 'articlefailedcount',
				totalarticle.count 'totalarticlecount'
			FROM Users u WITH(NOLOCK)
			INNER JOIN @userids uid ON uid.userid = u.userid
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			LEFT JOIN ( SELECT us.userId, tm.siteId, COUNT(tm.PostId) 'count' 
			            FROM ThreadMod tm
						INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
						INNER JOIN @userids us ON us.userid = te.userid
						 WHERE tm.Status = 3 GROUP BY us.userId, siteId) AS passed ON passed.userId = u.userId AND passed.siteid = s.siteid
			LEFT JOIN ( SELECT us.userId, tm.siteId, COUNT(tm.PostId) 'count' 
			            FROM ThreadMod tm
						INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
						INNER JOIN @userids us ON us.userid = te.userid
						 WHERE tm.Status = 4 GROUP BY us.userId, siteId) AS failed ON failed.userId = u.userId AND failed.siteid = s.siteid
			LEFT JOIN ( SELECT us.userId, f.siteId, COUNT(te.EntryId) 'count' 
			            FROM ThreadEntries te
						INNER JOIN Forums f ON f.forumid = te.forumid
						INNER JOIN @userids us ON us.userid = te.userid
						GROUP BY us.userId, siteId) AS totalposts ON totalposts.userId = u.userId AND totalposts.siteid = s.siteid
			LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' 
			            FROM ArticleMod am
						INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
						INNER JOIN @userids us ON us.userid = ge.editor
						WHERE ge.Type <= 1000 AND am.Status = 3 GROUP BY editor, am.siteId) AS articlepassed ON articlepassed.editor = u.userId AND articlepassed.siteid = s.siteid
			LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
						INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
						INNER JOIN @userids us ON us.userid = ge.editor
						WHERE ge.Type <= 1000 AND am.Status = 4 GROUP BY editor, am.siteId) AS articlefailed ON articlefailed.editor = u.userId AND articlefailed.siteid = s.siteid
			LEFT JOIN ( SELECT editor, ge.siteId, COUNT(ge.h2g2Id) 'count' 
			            FROM GuideEntries ge
			            INNER JOIN @userids us ON us.userid = ge.editor
						WHERE ge.Type <= 1000
						GROUP BY editor, ge.siteId) AS totalarticle ON totalarticle.editor = u.userId AND totalarticle.siteid = s.siteid
			LEFT JOIN  GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
			WHERE g.GroupID = @EditorGroupID OR @issuperuser = 1
			ORDER BY u.UserID DESC, s.SiteID

			-- Optimise for a user with the right characteristics ( user with email address with lowish content ).
			--OPTION (OPTIMIZE FOR (@usertofindid = 42))
	END
	ELSE
	BEGIN
		-- Get all the user entries for the given email fo sites that the viewing user is an Editor
		SELECT	u.UserID,
				u.UserName,
				u.LoginName,
				u.Email,
				u.Active,
				p.PrefStatus,
				us.UserStatusDescription,
				ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
				p.PrefStatusChangedDate,
				p.DateJoined,
				p.SiteID,
				s.ShortName,
				s.urlname,
				passed.count 'postpassedcount',
				failed.count 'postfailedcount',
				totalposts.count 'totalpostcount',
				articlepassed.count 'articlepassedcount',
				articlefailed.count 'articlefailedcount',
				totalarticle.count 'totalarticlecount'
			FROM Users u WITH(NOLOCK)
			INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
			INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
			INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
			INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
			LEFT JOIN  GroupMembers g WITH(NOLOCK) ON g.UserID = @ViewingUserID AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID
			LEFT JOIN ( SELECT userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
						INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
						 WHERE tm.Status = 3 GROUP BY userId, siteId) AS passed ON passed.userId = u.userId AND passed.siteid = s.siteid
			LEFT JOIN ( SELECT userId, tm.siteId, COUNT(tm.PostId) 'count' FROM ThreadMod tm
						INNER JOIN ThreadEntries te ON te.EntryId = tm.PostId
						 WHERE tm.Status = 4 GROUP BY userId, siteId) AS failed ON failed.userId = u.userId AND failed.siteid = s.siteid
			LEFT JOIN ( SELECT userId, f.siteId, COUNT(te.EntryId) 'count' FROM ThreadEntries te
						INNER JOIN Forums f ON f.forumid = te.forumid
						 GROUP BY userId, siteId) AS totalposts ON totalposts.userId = u.userId AND totalposts.siteid = s.siteid
			LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
						INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
						 WHERE am.Status = 3 GROUP BY editor, am.siteId) AS articlepassed ON articlepassed.editor = u.userId AND articlepassed.siteid = s.siteid
			LEFT JOIN ( SELECT editor, am.siteId, COUNT(am.h2g2Id) 'count' FROM ArticleMod am
						INNER JOIN GuideEntries ge ON ge.h2g2Id = am.h2g2Id
						 WHERE am.Status = 4 GROUP BY editor, am.siteId) AS articlefailed ON articlefailed.editor = u.userId AND articlefailed.siteid = s.siteid
			LEFT JOIN ( SELECT editor, ge.siteId, COUNT(ge.h2g2Id) 'count' FROM GuideEntries ge
						GROUP BY editor, ge.siteId) AS totalarticle ON totalarticle.editor = u.userId AND totalarticle.siteid = s.siteid
			WHERE u.userid = @usertofindid AND (g.GroupID = @EditorGroupID OR @issuperuser = 1)
			ORDER BY u.UserID DESC, s.SiteID

			-- Optimise for a user with the right characteristics ( user with email address with lowish content ).
			OPTION (OPTIMIZE FOR (@usertofindid = 42))
	END



