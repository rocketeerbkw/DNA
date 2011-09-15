select * from dbo.admin_dbchanges

-- tables to delete
/*
delete table dbo.AdultPreMigrationSiteOptions
dbo.aaaTemp
dbo.ArticleExtraInfoFrom606
dbo.ArticleTextFrom606
dbo.ArticleModCube
dbo.ArticleModReferralsCube
dbo.AutoModAudit
dbo.AutoModAuditReasons
dbo.AutoModTrustZones
dbo.backup_reviewforummembers
dbo.badtext
dbo.badtext2
dbo.BIEventQueueOld
dbo.BlankNicknameBugIn606
dbo.blog532users
dbo.BRAlteredEntries
dbo.commentforumscloned
dbo.commentfourm532fix
dbo.CookieHistory
dbo.dbo.ArticleLocationOld
dbo.forumsiteidupdate
dbo.gm2
dbo.groupmembers_modcockup
dbo.icanGuideEntries
dbo.jim_siteopenclose
dbo.longusernames

*/

-- Tables to truncate
/*
dbo.ArticleKeyPhrases
dbo.ArticleKeyPhrasesNonVisible
dbo.ArticleMod
dbo.ArticleModHistory
dbo.ArticleModIPAddress
dbo.BannedEmails
dbo.BannedIPAddress
dbo.BBCDivision
dbo.BIEventQueue
dbo.BIEventQueueHandled
dbo.blobs ??
dbo.Clubs
dbo.ClubPermissions
dbo.ClubVotes
dbo.CommentForums
dbo.ComplaintDuplicates
dbo.DNASystemMessages
dbo.EditHistory
dbo.EMailEventQueue
dbo.ExLinkMod
dbo.ExLinkModHistory
dbo.ExModEventQueue
dbo.FastModForums
dbo.ForumScheduledEvents
dbo.FrontPageElements
dbo.GeneralMod
dbo.GeneralModIPAddress
dbo.HierarchyClubMembers
dbo.ImageAsset
dbo.InstantEMailAlertList
dbo.IPLookupReason
dbo.KeyPhrases
dbo.MBStatsHostsPostsPerTopic
dbo.MBStatsModStatsPerTopic
dbo.MBStatsModStatsTopicTotals
dbo.MBStatsTopicTotalComplaints
dbo.MediaAsset
dbo.MediaAssetIPAddress
dbo.MediaAssetLibrary
dbo.MediaAssetMod
dbo.MediaAssetUploadQueue
dbo.MessageBoardAdminStatus
dbo.ModerationBilling

*/

select top 100 * from dbo.Forums
select count(*) from dbo.Forums
select count(*) from dbo.Forums (nolock) where siteid not in (1,66)

select count(*) from dbo.FaveForums (nolock) ff
join forums f on f.forumid=ff.forumid
where f.siteid<>1

select count(*) from preferences where siteid=1
select count(*) from forums where siteid=1

select distinct editor into aaa_distinct_ge_editors from guideentries where siteid=1

select distinct userid into aaa_distinct_te_users from threadentries te
join forums f on f.forumid=te.forumid
where siteid=1

select userid, datejoined from users where userid in 
(
	select * from 
	(
		select userid from aaa_distinct_te_users
		union
		select editor from aaa_distinct_ge_editors
	) s
	except 
	select userid from preferences where siteid=1
)
order by datejoined desc

select * from users where userid in (14605468
,14603705
,14601716
,14599018
,14594915
,14594850
,14588330
,14586643
,14586633
,14586000
)

select * from guideentries where editor=14588330
select * from threadentries te
join forums f on f.forumid=te.forumid
where siteid=1
and userid=14588330

select * from preferences p
join users u on p.userid=u.userid
join forums f on f.forumid = u.journal
where p.siteid=1 and f.siteid<>1


select top 1 * from users

select count(*) from threadentries te
join threads t on t.threadid=te.threadid
where t.siteid not in (1,66) -- 99,700,912

select count(*) from threads t
where t.siteid not in (1,66) --7,626,392

select count(*) from guideentries
where siteid not in (1,66) -- 8,410,134


