
	select count(*) from forums (nolock)
	where siteid not in (1,66)

	select count(*) from forums (nolock)
	where siteid in (1,66)

select count(*)
from threadentries te (nolock)
left join forums (nolock) f on f.forumid=te.forumid
where f.forumid is null
-- 99,730,112
-- 98,719,321
-- 95,838,313
-- 95,838,313
-- 94,829,084

select count(*) from ThreadEntriesH2G2 (nolock)
-- 1,998,460
-- 3,642,410 after 52m

select count(*)
from threadentries te
left join forums f on f.forumid=te.forumid
where f.forumid is not null
-- 10,373,636

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadEntries'), NULL, NULL, 'LIMITED')

SELECT *
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ForumLastUpdated'), NULL, NULL, 'LIMITED')


select count(*) from threads
-- 8,268,138
select count(*) from threads where siteid in (1,66)
-- 640,474

select * from dbo.ForumLastUpdated

select count(*) from threadentries (nolock) where forumid is null
select count(*) from dbo.ForumReview

select * from dbo.FrontPageElements where siteid in (1,66)

select * from dbo.GroupMembers where siteid in (1,66)

exec dbo.dbu_listfkeys 'ArticleMod'

select count(distinct h2g2id) from dbo.GuideEntryPermissions
--8,671,657
select count(*) from dbo.GuideEntryPermissions gep
join guideentries ge on ge.h2g2id=gep.h2g2id
where ge.siteid in (1,66)
--277,118

select count(*) from dbo.GuideEntryVersions
--1,120,433
select count(*) from dbo.GuideEntryVersions gev
join guideentries ge on ge.entryid=gev.entryid
where ge.siteid in (1,66)
--215,209

select count(*) from dbo.Hierarchy
select count(*) from dbo.Hierarchy where siteid in (1,66)

select * from dbo.HierarchyNodeTypes


select * from dbo.Clubs where siteid in (1,66)
select * from dbo.ClubPermissions
select * from dbo.ClubVotes
select * from dbo.ClubActionNames
select * from dbo.ClubMemberActions where clubid=11


select * from dbo.ImageAsset
select * from dbo.MediaAsset where siteid not in (65,71)

select * from dbo.Inclusions
select * from dbo.InstantEMailAlertList

select * from dbo.IPLookupReason

select * from dbo.Journals j
-- 6,053,375
select count(*) from dbo.Journals j
where siteid in (1,66)
-- 380,998

select userid,siteid,count(*) from journals
group by userid,siteid having count(*) <> 1


select count(*) from dbo.KeyArticles 
select count(*) from dbo.KeyArticles where siteid in (1,66)

select * from dbo.KeyPhrases

select PhraseNamespaceID,count(*) from dbo.ArticleKeyPhrases group by PhraseNamespaceID
-- 20,081,235
select * from dbo.ArticleKeyPhrases where siteid in (1,66)
select count(*) from dbo.ArticleKeyPhrasesNonVisible

select * from dbo.PhraseNameSpaces

select * from dbo.Keywords

select count(*) from dbo.Links l
 INNER JOIN GuideEntries g ON l.DestinationType = 'article' AND l.DestinationID = g.h2g2ID
where g.siteid in (1,66)


select count(*) from dbo.MastHeads where siteid not in (1,66)


select * from dbo.longusernames

select * from dbo.MailingLists
select * from dbo.Mailshots
select * from dbo.MailTokens
select * from dbo.MasterSettings
select count(*) from dbo.Mastheads where siteid in (1,66)

select * from dbo.MBStatsHostsPostsPerTopic
select count(*) from dbo.MBStatsModStatsPerTopic
select count(*) from dbo.MBStatsModStatsTopicTotals
select count(*) from dbo.MBStatsTopicTotalComplaints

select * from dbo.Membership

select * from dbo.MessageBoardAdminStatus where siteid in (1,66)

select * from dbo.ModAction

select * from dbo.ModerationBilling

select * from dbo.ModerationClass
select * from dbo.ModerationClassMembers
select * from sites where siteid in (1,66)

select count(*) from threads (nolock)
where siteid not in (1,66)
-- 6927664
-- 6097664

select * from dbo.NameSpaces
dbo.ModTrigger
dbo.ModTermMapping
dbo.ModStatus
dbo.ModReason
dbo.Moderators

select * from dbo.NodeLink nl
join hierarchy h on h.nodeid=nl.nodeid

select * from dbo.NodeMembership
select * from dbo.admin_dbchanges where uid='jim: 24902EDA-B00F-43D7-ABF5-E3AC234D086C'
select * from dbo.OldRecommendedGroupData
select count(*) from dbo.OldSessions
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('OldSessions'), NULL, NULL, 'LIMITED')--'DETAILED')

select count(*) from dbo.PageVotes
select top 10 *  from dbo.PageVotes where itemtype <>1
select count(*) from dbo.PageVotes pv
join guideentries g on g.h2g2id=pv.itemid

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('pagevotes'), NULL, NULL, 'LIMITED')--'DETAILED')
select * from dbo.PeopleWatch

select * from dbo.PhraseNameSpaces

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('PostDuplicates'), NULL, NULL, 'LIMITED')--'DETAILED')
select count(*) from dbo.PostDuplicates -- 100,682,065
select count(*) from dbo.PostDuplicates pd
join forums f on f.forumid=pd.forumid
where f.siteid in (1,66) -- 3,871,025

select hashvalue,count(*) from dbo.PostDuplicates
group by hashvalue having count(*) > 1

select * from postduplicates pd
join forums f on f.forumid=pd.forumid where hashvalue in (
'3497E924-BEDC-5F88-B41B-4D3A125B3AF0',
'09DEB5BB-3E08-98AF-A208-4F18DC00094A',
'8A25A0D8-08AC-ABC0-B3F9-4F32DA3078DD',
'812C4C19-2C97-C9FB-8AF6-5C1C4E50EA7A',
'578B2859-E0D9-CEE6-AD53-700C4AAAF30C',
'4B22BA69-07F3-EE19-130C-774F30A107C9',
'99198F38-EBF7-0EC4-22E9-7F7773FC2DE5',
'E8B71EED-3CB1-3398-3757-80CE1AE30637',
'8ADDBD53-3FB9-C702-DCAB-935DA25A9046',
'9DC91667-80A4-2754-889B-95A1B72B63CF',
'F6AE8AB7-37F0-206E-A50B-9BA8A86F4B69',
'F04C9796-6FF5-D10A-D58F-A0AB156C6883',
'5EFB849D-73B5-FD14-19DB-B0D1C3771B43',
'B35A0B29-E20B-8EA7-1F2F-BB675F5D4529',
'AAC3B17A-B6A7-FA4C-A8E1-BC2EF85DBDF1',
'A76FA763-DEBE-8249-C673-C7FA14391993',
'338BF456-61A3-8917-9524-D7F31228F0A5',
'E19320B3-4929-A8FD-51C3-DBB6224A8D1D',
'241FABB2-29E4-D75D-8B3A-DF3833CCEED0',
'C0B40693-7444-8335-A4EB-E38438FC9E28',
'ABD43C6F-6929-47AD-A21C-E4BC782A24A7',
'96E11090-5A54-582A-E0B9-E82E4BA83741',
'55A70BD4-3142-29E7-3D59-FD3ED6212965')

select * from dbo.PostEvents

select count(*) from PostDuplicatesH2G2 (nolock)

select * from dbo.PostHidden
select * from dbo.PostingQueue
select * from dbo.PostSytle

select count(*) from dbo.Preferences (nolock) -- 5,853,955
select count(*) from dbo.Preferences where siteid in (1,66) -- 174,572
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Preferences'), NULL, NULL, 'LIMITED')--'DETAILED')
-- 885,888 kb

select count(*) from  dbo.PreModPostings
select * from  dbo.PreModPostings where siteid=1

select * from dbo.PreviewConfig where siteid=1

select * from dbo.Profanities

select count(*) from dbo.ProfanitiesBackup

select count(*) from dbo.ProfanityGroupMembers

select count(*) from dbo.ProfanityGroups

select * from dbo.ProlificScribeGroupUpdates

select * from dbo.RecentSearch

select count(*) from dbo.Researchers r (nolock)
select count(*) from dbo.Researchers r
left join guideentries g on g.entryid=r.entryid
where g.siteid =1
select count(*) from dbo.Researchers r
left join guideentries g on g.entryid=r.entryid
where g.siteid in (1,66)


select * from Researchers where entryid=8598112


select count(*) from dbo.ReviewForumMembers
select count(*) from dbo.ReviewForumMembers rfm
left join forums f on f.forumid= rfm.forumid
where ISNULL(f.siteid,0) not in (1,66)

select count(*) from dbo.ReviewForumMembers rfm
left join guideentries g on g.h2g2id = rfm.h2g2id
where g.siteid in (1,66)

select count(*) from dbo.ReviewForums
select count(*) from dbo.ReviewForums where siteid not in (1,66)

select * from dbo.ReviewForums order by siteid

select count(*) from dbo.RiskModDecisionsForThreadEntries
select count(*) from dbo.RiskModDecisionsForThreadEntries where siteid in (1,66)
select count(*) from dbo.RiskModDecisionsForThreadEntries where siteid in (66)

select * from dbo.RiskModerationState where ison=1

select * from dbo.RiskModThreadEntryQueue

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('RiskModDecisionsForThreadEntries'), NULL, NULL, 'LIMITED')--'DETAILED')
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('RiskModThreadEntryQueue'), NULL, NULL, 'LIMITED')--'DETAILED')
--216040
-- 41320

select * from dbo.RouteLocation

select * from dbo.Salt

select * from dbo.ScoutDetails
select g.siteid,* from dbo.ScoutRecommendations sr
left join guideentries g on g.entryid=sr.entryid
where ISNULL(g.siteid,0) not in (1,66)

select count(*) from dbo.SearchResults
select * from dbo.SendRequests

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Sessions'), NULL, NULL, 'LIMITED')--'DETAILED') -- 22.8Gb
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('SessionsOld'), NULL, NULL, 'LIMITED')--'DETAILED') -- 1.7Gb

select count(*) from dbo.Sessions -- 78,047,757
select count(*) from dbo.SessionsOld -- 35,625,867
-- 58.91% free
-- 71.94% free

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('SignInUserIDMapping'), NULL, NULL, 'LIMITED')--'DETAILED') -- 1.7Gb

select count(*) from dbo.SignInUserIDMapping
select * from dbo.SignInUserIDMapping
select top 10 * from users order by userid desc
select * from users where userid=13626041	

13626041	NULL	15029

declare @max int
select @max = max(userid) from users
DBCC CHECKIDENT ('SignInUserIDMapping', RESEED,@max);
DBCC CHECKIDENT ('SignInUserIDMapping', NORESEED);

select count(*) from dbo.SiteActivityItems
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('SiteActivityItems'), NULL, NULL, 'LIMITED')--'DETAILED') -- 1.7Gb
-- 450Mb
exec dbo.dbu_listfkeys 'SiteActivityItems'
alter table UserSiteEvents drop constraint FK_UserSiteEvents_SiteActivityItems

select * from dbo.SiteActivityQueue
select * from dbo.SiteActivityQueueErrors
select * from dbo.SiteActivityTypes

select count(*) from dbo.SiteDailySummaryReport

select * from dbo.SiteKeyPhrases

dbo.SiteModStatusSnapshot0801111738

select * from dbo.SiteOptions where siteid in (0,1,66)

select * from dbo.Sites
exec dbo.dbu_listfkeys 'Sites'
select * from dbo.SiteSkins

select * from dbo.SiteStats

select * from dbo.SiteSuffixUpdate

select * from dbo.SiteTopicsOpenCloseTimes where siteid in (1,66)
select * from dbo.SkinColours
select * from dbo.Smileys

select * from dbo.SNeSActivityQueue
select * from dbo.SNeSApplicationMetadata

select count(*) from dbo.sql_logspace_used
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('sql_logspace_used'), NULL, NULL, 'LIMITED')--'DETAILED') -- 1.7Gb

select count(*) from dbo.Stats_Postings
select * from dbo.StickyThreads st
left join threads t on t.threadid=st.threadid
where t.siteid in (1,66)

select * from dbo.SubDetails
select * from dbo.SubDetails sd
join preferences p on p.userid=sd.subeditorid
where p.siteid in (1,66)

select * from dbo.SubsArticles
select * from dbo.SubsArticles sa
join guideentries g on g.entryid=sa.entryid
where g.siteid in (1,66)

select count(*) from dbo.TeamMembers (nolock) -- 6,060,526
select count(*) from dbo.Teams t (nolock) -- 6,058,717
left join forums f on f.forumid = t.forumid
where ISNULL(f.siteid,0) not in (1,66) -- 381,090

select forumid,count(*) from teams
group by forumid having count(*) > 1

select * from dbo.TempUserList

select * from dbo.TermsActionLookup
select * from dbo.TermsByModClass
select * from dbo.TermsByModClassHistory
select * from dbo.TermsLookup
select * from dbo.TermsUpdateHistory

select * from dbo.testtable

select * from dbo.TextBoxElementKeyPhrases
select * from dbo.TextBoxElements

select count(*) from dbo.ThreadEditHistory 

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadEntriesIPAddress'), NULL, NULL, 'LIMITED')--'DETAILED') 
-- 10,962,960
select count(*) from dbo.ThreadEntriesIPAddress -- 90,945,520

select * from dbo.ThreadEntryEditorPicks
select count(*) from dbo.ThreadEntryRating -- 1271394
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadEntryRating'), NULL, NULL, 'LIMITED')--'DETAILED') 
select count(*) from dbo.ThreadEntryRating where siteid in (1,66) -- 0

select * from dbo.ThreadKeyPhrases where siteid in (1,66)

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadMod'), NULL, NULL, 'LIMITED')--'DETAILED') 
-- 9.4Gb
select count(*) from dbo.ThreadMod -- 30,730,538
exec dbo.dbu_listfkeys 'ThreadMod'

select count(*) from dbo.ThreadModAwaitingEmailVerification
select count(*) from dbo.ThreadModCube

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadModHistory'), NULL, NULL, 'LIMITED')--'DETAILED') 
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadModOld'), NULL, NULL, 'LIMITED')--'DETAILED') 

select count(*) from dbo.ThreadModHistory
select count(*) from dbo.ThreadModIPAddress
select count(*) from dbo.ThreadModOld

select count(*) from dbo.ThreadPermissions
select count(*) from dbo.ThreadPermissions tp
left join threads t on t.threadid=tp.threadid
where ISNULL(t.siteid,0) not in (1,66)

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadPostings'), NULL, NULL, 'LIMITED')--'DETAILED') 
-- 8Gb
select count(*) from dbo.ThreadPostings -- 92,039,875
select count(*) from dbo.ThreadPostings tp
left join threads t on t.threadid=tp.threadid
where ISNULL(t.siteid,0) in (1,66) -- 10,235,135

select count(*) from dbo.ThreadPostingsQueue
select * from dbo.ThreadTaglimits
select count(*) from dbo.ThreadVotes

select * from dbo.TopFives where siteid in (1,66)

select * from dbo.Topics where siteid in (1,66)

select * from dbo.Totals

exec dbo.dbu_listfkeys 'UIField'
select * from dbo.UIField
select * from dbo.UITemplate
select * from dbo.UITemplateField

select * from dbo.UploadMod
select * from dbo.Uploads
select * from dbo.UserEventScore

select count(*) from dbo.UserLastPosted
select count(*) from dbo.UserLastPosted where siteid in (1,66)

select * from dbo.UserModStatus
select count(*) from dbo.UserPostEvents
select * from dbo.UserPrefStatusAudit
select * from dbo.UserPrefStatusAuditActions
select count(*) from dbo.UserReputationScore
select * from dbo.UserReputationThreshold

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('users'), NULL, NULL, 'LIMITED')--'DETAILED') 
-- 2.3Gb
select count(*) from users (nolock) -- 4107933
select count(*) from users u
join preferences p on p.userid=u.userid
where p.siteid in (1,66) -- 174574
exec dbo.dbu_listfkeys 'Users'


 dbo.UserSiteEvents

select count(*) from dbo.UsersTags

select * from dbo.UserStatuses
select * from dbo.UserSubscriptions
select * from dbo.UserSubscriptions us
join users u on u.userid=us.userid

select * from dbo.UserTagLimits
 dbo.UserTags
select count(*) from dbo.UserTeams
select count(*) from dbo.UserTeams where siteid in (1,66)

select * from dbo.VideoAsset
select * from dbo.ViewedMovies

SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('VoteMembers'), NULL, NULL, 'LIMITED')--'DETAILED') 
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Votes'), NULL, NULL, 'LIMITED')--'DETAILED') 

select count(*) from dbo.VoteMembers
select count(*) from dbo.Votes

select type,count(*) from dbo.Votes
group by type
select * from dbo.Whiteblobs

select count(*) from dbo.ww2faves
select count(*) from dbo.YourWorldEntries

select a.*,g.entryid from dbo.ArticleSubscriptions a
left join guideentries g on g.entryid=a.entryid
where g.entryid is null and a.siteid not in (1,66)

select * from guideentries g1
left join guideentries g2 on g2.entryid=g1.basedon
where g1.basedon is not null and g2.entryid is null

select count(*) from guideentries g1
left join guideentries g2 on g2.entryid=g1.basedon
where g1.basedon is not null 


select * from guideentries where entryid=80166

select * from Researchers r
left join users u on u.userid=r.userid
where u.userid is null

select distinct userid from researchers r
where exists (select * from guideentries where editor=r.userid)
and not exists (select * from users u where u.userid=r.userid)
order by userid

