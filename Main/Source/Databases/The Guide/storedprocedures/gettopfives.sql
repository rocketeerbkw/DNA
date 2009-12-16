CREATE PROCEDURE gettopfives	
								@siteid int = 1,
								@groupname varchar(255) = NULL
As

DECLARE @isActionNetwork int
SELECT @isActionNetwork=1 FROM Sites WHERE siteid=@siteid AND urlname='actionnetwork'

SELECT	t.GroupName,
	t.GroupDescription,
	t.SiteID,
	f.ForumID,
	t.ThreadID,  
	t.ClubID,
	t.TopicID,
	
	--TITLE
	CASE 	
		WHEN th.FirstSubject IS NOT NULL AND th.FirstSubject <> '' THEN th.FirstSubject
		WHEN u.UserName IS NOT NULL THEN 'Journal of ' + u.UserName
		WHEN c.Name IS NOT NULL	THEN c.Name
		WHEN th.FirstSubject IS NOT NULL AND th.FirstSubject = '' THEN 'No Subject'
		WHEN f.Title = '' THEN 'No Subject' 		
		ELSE f.Title 
		END as Title,
	--SUBJECT	
	CASE t.GroupName		
		WHEN  'MostRecentCampaignDiaryEntries' THEN te.text
		WHEN  'MostRecentComments' THEN             te2.text
		WHEN  'MostRecentEvents' THEN				te.text
		WHEN  'MostRecentNotice' THEN				te.text
		ELSE g.Subject
	END AS Subject,
	
	t.UserID,
	g.EntryID, 
	g.h2g2ID, 	
	t.Rank,
	'ActualID' = 'A' + CAST(g.h2g2ID AS varchar(40)),			
	'UserName' = u1.UserName,
	'FirstNames' = u1.FirstNames,
	'LastName' = u1.LastName,
	'NodeID' = t.NodeID,
	u1.Area,
	u1.TaxonomyNode,
	'UserTitle' = p.Title,
	'SiteSuffix' = p.SiteSuffix,
	u.status,
	'Journal' = J.ForumID,
	u.Active,
	g.extraInfo, 
	th.EventDate,
	CASE t.GroupName		
		WHEN  'MostRecentCampaignDiaryEntries' THEN te.PostStyle
		WHEN  'MostRecentComments' THEN  te2.PostStyle
		WHEN  'MostRecentEvents' THEN  te.PostStyle
		WHEN  'MostRecentNotice' THEN  te.PostStyle
		ELSE 2
	END AS PostStyle,
	te.EntryID 'PostId',
	te2.EntryID 'CommentId',
	
	--ITEM AUTHOR ID  	
	CASE t.GroupName
		WHEN  'MostRecentIssues' THEN  g.Editor
		WHEN  'MostRecentIssue' THEN  g.Editor
		WHEN  'MostRecentConversations' THEN ( SELECT TOP 1 te.userid FROM ThreadEntries AS te WITH(NOLOCK) WHERE te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.Hidden IS NULL ORDER BY te.dateposted DESC )
		WHEN  'MostRecentCampaignDiaryEntries' THEN ( SELECT TOP 1 te.userid FROM ThreadEntries AS te WITH(NOLOCK) WHERE te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.Hidden IS NULL ORDER BY te.PostIndex )
		WHEN  'MostRecentComments' THEN ( SELECT TOP 1 te.userid FROM ThreadEntries AS te WITH(NOLOCK) WHERE te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.Hidden IS NULL ORDER BY te.dateposted DESC )
		WHEN  'MostRecentEvents' THEN ( SELECT TOP 1 te.userid FROM ThreadEntries AS te WITH(NOLOCK) WHERE te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.Hidden IS NULL ORDER BY te.PostIndex )
		WHEN  'MostRecentNotice' THEN ( SELECT TOP 1 te.userid FROM ThreadEntries AS te WITH(NOLOCK) WHERE te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.Hidden IS NULL ORDER BY te.PostIndex )
		ELSE NULL
	END AS ItemAuthorID,
	
	--DATE ITEM WAS UPDATED
	CASE t.GroupName
		WHEN  'MostRecentIssues' THEN g.LastUpdated
		WHEN  'MostRecentIssue' THEN g.LastUpdated
		WHEN  'MostRecentConversations' THEN th.LastUpdated
		WHEN  'MostRecentCampaignDiaryEntries' THEN th.LastUpdated
		WHEN  'MostRecentComments' THEN th.LastUpdated
		WHEN  'MostRecentEvents' THEN th.LastUpdated
		WHEN  'MostRecentNotice' THEN th.LastUpdated
		ELSE NULL
	END AS DateUpdated,	

	--LINKITEMTYPE - PARENT ITEM TYPE
	CASE t.GroupName
		WHEN 'MostRecentCampaignDiaryEntries' THEN 'Campaign'						
		WHEN 'MostRecentComments' THEN 
			CASE
				WHEN t.clubid IS NOT NULL THEN  'Campaign'				
				ELSE dbo.udf_getguideentrytype( (SELECT ge2.type FROM guideentries AS ge2 WITH(NOLOCK) WHERE forumid = t.ForumID) )
			END				
		ELSE NULL	
	END AS LinkItemType,				
	
	--LINKITEMID - PARENT ITEM ID
	CASE t.GroupName
		WHEN  'MostRecentCampaignDiaryEntries' THEN ( SELECT c2.clubid FROM clubs AS c2 WITH(NOLOCK) where c2.journal = t.forumid  )		
		WHEN 'MostRecentComments' THEN 
			CASE 
				WHEN t.clubid IS NOT NULL THEN t.clubID 
				ELSE  (SELECT ge2.H2G2ID FROM guideentries AS ge2 WITH(NOLOCK) WHERE forumid = t.ForumID )
			END			
		ELSE NULL
	END AS LinkItemID,
	
	--LINKITEMNAME - PARENT ITEM NAME
	CASE t.GroupName
		WHEN  'MostRecentCampaignDiaryEntries' THEN ( SELECT c2.Name FROM clubs AS c2 WITH(NOLOCK) where c2.journal = t.forumid)		
		WHEN 'MostRecentComments' THEN 
			CASE 
				WHEN t.clubid IS NOT NULL THEN (SELECT c.Name  FROM clubs AS C WITH(NOLOCK) WHERE c.clubID = t.ClubID ) 
				ELSE (SELECT ge2.subject FROM guideentries AS ge2 WITH(NOLOCK) WHERE forumid = t.ForumID) 		
			END
	END AS LinkItemName	
	
FROM TopFives AS t WITH(NOLOCK)
LEFT JOIN Forums AS f WITH(NOLOCK) ON f.ForumID = t.ForumID
LEFT JOIN Users AS u WITH(NOLOCK) ON u.Journal = t.ForumID
LEFT JOIN Users AS u1 WITH(NOLOCK) ON u1.UserID = t.UserID
LEFT JOIN GuideEntries AS g WITH(NOLOCK) ON g.h2g2ID = t.h2g2ID
LEFT JOIN [Threads] AS th WITH(NOLOCK) ON th.ThreadID = t.ThreadID
LEFT JOIN Clubs AS c WITH(NOLOCK) ON c.ClubID = t.ClubID 
LEFT JOIN GuideEntries AS g2 WITH(NOLOCK) ON g2.h2g2ID = c.h2g2ID
LEFT JOIN Preferences p WITH(NOLOCK) ON (p.UserID = u.UserID) and (p.SiteID = f.SiteID) 
-- Join on ThreadEntries for ActionNetwork only
LEFT JOIN ThreadEntries AS te WITH(NOLOCK) ON @isActionNetwork=1 AND te.ThreadID = t.ThreadID AND te.ForumID = t.ForumID AND te.PostIndex = 0 AND te.Hidden IS NULL
-- Join on ThreadEntries again, for ActionNetwork only
LEFT JOIN ThreadEntries AS te2 WITH(NOLOCK) ON @isActionNetwork=1 AND te2.ThreadID = t.ThreadID AND te2.ForumID = t.ForumID AND te2.Hidden IS NULL
 			AND te2.postindex = (SELECT MAX(te3.postindex) FROM threadentries AS te3 WITH(NOLOCK) WHERE @isActionNetwork=1 AND te3.ThreadID = t.ThreadID AND te3.ForumID = t.ForumID AND te3.Hidden IS NULL)
LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = f.SiteID 		
WHERE t.SiteID = @siteid AND (t.GroupName = @groupname OR @groupname IS NULL)
						 AND (g.Hidden IS NULL OR g.Hidden = 0)
						 AND (g2.Hidden IS NULL OR g2.Hidden = 0)
						 AND (th.VisibleTo = 0 OR th.VisibleTo IS NULL)
ORDER BY GroupName, Rank/*, te.dateposted DESC */
