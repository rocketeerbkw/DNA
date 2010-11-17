CREATE PROCEDURE ratingthreadsreadbyuid @uid varchar(255), @siteid int
AS
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	SELECT	@uid as uid,
			th.threadid,
			th.ThreadPostCount,
			te.entryid As id,
			fr.rating,
			te.DatePosted AS Created, 
			te.UserID, 
			cf.ForumID, 
			cf.Url as parentUri,
			te.text, 
			te.Hidden, 
			te.PostStyle, 
			cf.UID AS forumuid, 
			u.Journal AS userJournal, 
			u.UserName, 
			u.Status AS userstatus, 
			CASE WHEN groups.UserID IS NULL THEN 0 ELSE 1 END AS userIsEditor,
			te.lastupdated as lastupdated,
			case when teep.entryid is not null then 1 else 0 end as 'IsEditorPick',
			te.PostIndex as 'Index'   
	FROM dbo.threads th
	INNER JOIN dbo.threadentries te ON te.threadid = th.threadid
	INNER JOIN dbo.forumreview fr ON fr.entryid = te.entryid
	INNER JOIN dbo.commentforums cf ON te.forumid = cf.forumid
	INNER JOIN dbo.Users u ON u.UserID = te.UserID 
	INNER JOIN dbo.Sites AS s ON s.SiteID = cf.SiteID
	LEFT OUTER JOIN
					(SELECT     
						gm.UserID, 
						gm.siteid
                    FROM dbo.Groups g INNER JOIN
					dbo.GroupMembers gm ON gm.GroupID = g.GroupID
					WHERE g.Name = 'EDITOR' and gm.siteid = @siteid) 
					AS groups ON groups.UserID = u.UserID
	left join threadentryeditorpicks teep  on te.entryid = teep.entryid
 	WHERE cf.uid=@uid 
	AND s.SiteID=@siteid 
	AND te.postindex = 0
