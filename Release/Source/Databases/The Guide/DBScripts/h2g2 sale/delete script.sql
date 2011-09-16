USE [master]
GO
ALTER DATABASE [NewGuide] SET RECOVERY SIMPLE WITH NO_WAIT
GO
ALTER DATABASE [NewGuide] SET RECOVERY SIMPLE
GO
USE NewGuide

------------------------------------------------------------------------------------
-- Make all users who have created at least one guide entry, or made at least one post to h2g2
-- has a preference record for site 1

set tran isolation level read uncommitted

-- find all the users that do not have a pref for h2g2
select distinct userid into #tmp_usersnopref
from users u
where not exists (select * from preferences p where p.userid=u.userid and p.siteid=1)

-- Find all users that have written guideentries and do not have a preference entry for h2g2
select distinct editor into #tmp_userh2g2guide
from guideentries g
where g.siteid =1 and g.editor in (select * from #tmp_usersnopref)

-- Find all users that have written threadentries and do not have a preference entry for h2g2
select distinct userid into #tmp_userh2g2posts
from threadentries te
join forums f on f.forumid = te.forumid
where f.siteid =1 and te.userid in (select * from #tmp_usersnopref)

-- Merge the two lists, removing duplicates
select userid into #tmp_userh2g2
from (select * from #tmp_userh2g2posts
	  union select * from #tmp_userh2g2guide) s

-- Create h2g2 preferences for all these users
DECLARE Users_Cursor CURSOR FAST_FORWARD FOR select * from #tmp_userh2g2

OPEN Users_Cursor 
declare @CurUserID int
FETCH NEXT FROM Users_Cursor 
INTO @CurUserID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC setdefaultpreferencesforuser @CurUserID,1
	FETCH NEXT FROM Users_Cursor INTO @CurUserID
END

CLOSE Users_Cursor 
DEALLOCATE Users_Cursor 
GO

------------------------------------------------------------------------------------
-- Drop the full text indexes
DROP FULLTEXT INDEX ON GuideEntries;
DROP FULLTEXT CATALOG GuideEntriesCat;

DROP FULLTEXT INDEX ON ThreadEntries;
DROP FULLTEXT CATALOG ThreadEntriesCat;

DROP FULLTEXT INDEX ON Hierarchy;
DROP FULLTEXT CATALOG HierarchyCat;

DROP FULLTEXT INDEX ON VGuideEntryText_memoryshare;
DROP FULLTEXT CATALOG VGuideEntryText_memoryshareCat;
GO

------------------------------------------------------------------------------------
-- Tables to drop
drop table dbo.AdultPreMigrationSiteOptions
drop table dbo.aaaTemp
drop table dbo.ArticleExtraInfoFrom606
drop table dbo.ArticleTextFrom606
drop table dbo.ArticleModCube
drop table dbo.ArticleModReferralsCube
drop table dbo.AutoModAudit
drop table dbo.AutoModAuditReasons
drop table dbo.AutoModTrustZones
drop table dbo.backup_reviewforummembers
drop table dbo.badtext
drop table dbo.badtext2
drop table dbo.BIEventQueueOld
drop table dbo.BlankNicknameBugIn606
drop table dbo.blog532users
drop table dbo.BRAlteredEntries
drop table dbo.commentforumscloned
drop table dbo.commentfourm532fix
drop table dbo.CookieHistory
drop table dbo.[dbo.ArticleLocationOld]
drop table dbo.forumsiteidupdate
drop table dbo.gm2
drop table dbo.groupmembers_modcockup
drop table dbo.icanGuideEntries
drop table dbo.jim_siteopenclose
drop table dbo.longusernames
drop table dbo.NicknamesPassedAndUsernameUpdated
drop table dbo.NicknamesPassedForUnmoderatedSitesAndBlogs
drop table dbo.OldRecommendedGroupData
drop table dbo.OldSessions -- 548Mb
drop table dbo.postevents
drop table dbo.PreferencesFix
drop table dbo.PrefsDiamondSuperLOL
drop table dbo.PrefsDiamondSuperLOLCompleteRows
drop table dbo.PrefsDiamondSuperLOLWithNoUDNG
drop table dbo.PrefStatus4
drop table dbo.PreModGroupUsersBackUp
drop table dbo.premodpostings24102009
drop table dbo.ProfanitiesBackup
drop table dbo.ProlificScribeGroupUpdates
drop table dbo.ReactiveBlogSites
drop table dbo.RestrictedGroupUsersBackUp
drop table dbo.SearchDataTo20101201
drop table dbo.SessionsOld -- 1.7Gb
drop table dbo.SiteModStatusSnapshot0801111738
drop table dbo.SiteSuffixUpdate
drop table dbo.sql_logspace_used
drop table dbo.temp_openclose
drop table dbo.tempClosedSites
drop table dbo.tempnewsriskmodtrialids
drop table dbo.testtable
drop table dbo.ThreadModOld -- 62Mb
drop table dbo.ThreadModTextProblem
drop table dbo.tomstatstable
drop table dbo.Totals
drop table dbo.UserPrefSnapshot0801111738
drop table dbo.usersWithWrongDateJoined
drop table dbo.usersWithWrongDateJoinedWithMinDate
drop table dbo.Whiteblobs
drop table dbo.ww2faves
GO

------------------------------------------------------------------------------------
-- Tables to truncate
DROP VIEW VArticleKeyphraseCounts
truncate table dbo.ArticleKeyPhrases

truncate table dbo.ArticleKeyPhrasesNonVisible

alter table dbo.ArticleModHistory drop constraint FK__ArticleMo__ModID__6AC9BBD9
truncate table dbo.ArticleMod

truncate table dbo.ArticleModHistory
truncate table dbo.ArticleModIPAddress
truncate table dbo.BannedEmails
truncate table dbo.BannedIPAddress
truncate table dbo.BBCDivision
truncate table dbo.BIEventQueue
truncate table dbo.BIEventQueueHandled
truncate table dbo.blobs
truncate table dbo.Clubs
truncate table dbo.ClubPermissions
truncate table dbo.ClubVotes
truncate table dbo.CommentForums
truncate table dbo.ComplaintDuplicates
truncate table dbo.DNASystemMessages
truncate table dbo.EditHistory
truncate table dbo.EMailEventQueue
truncate table dbo.ExLinkMod
truncate table dbo.ExLinkModHistory
truncate table dbo.ExModEventQueue
truncate table dbo.FastModForums
truncate table dbo.ForumScheduledEvents
truncate table dbo.FrontPageElements
truncate table dbo.GeneralMod
truncate table dbo.GeneralModIPAddress
truncate table dbo.HierarchyClubMembers
truncate table dbo.ImageAsset
truncate table dbo.InstantEMailAlertList
truncate table dbo.IPLookupReason
truncate table dbo.KeyPhrases
truncate table dbo.MBStatsHostsPostsPerTopic
truncate table dbo.MBStatsModStatsPerTopic
truncate table dbo.MBStatsModStatsTopicTotals
truncate table dbo.MBStatsTopicTotalComplaints
truncate table dbo.MediaAsset
truncate table dbo.MediaAssetIPAddress
truncate table dbo.MediaAssetLibrary
truncate table dbo.MediaAssetMod
truncate table dbo.MediaAssetUploadQueue
truncate table dbo.MessageBoardAdminStatus
truncate table dbo.ModerationBilling
truncate table dbo.Moderators
truncate table dbo.NicknameMod
truncate table dbo.NicknameModCube
truncate table dbo.NicknameModHistory
truncate table dbo.NodeLink
truncate table dbo.PageVotes
truncate table dbo.PhraseNameSpaces
truncate table dbo.PostingQueue
truncate table dbo.PreModPostings
truncate table dbo.PreviewConfig
truncate table dbo.RiskModDecisionsForThreadEntries -- saves about 250Mb
truncate table dbo.RiskModerationState
truncate table dbo.RiskModerationStateHelp
truncate table dbo.RiskModThreadEntryQueue
truncate table dbo.Salt
truncate table dbo.SendRequests
truncate table dbo.Sessions -- 22.8Gb

truncate table dbo.SignInUserIDMapping -- 487Mb
-- reset the identity column to the max UserId so that future user accounts have IDs that continue the sequence
declare @max int
select @max = max(userid)+1 from users
DBCC CHECKIDENT ('SignInUserIDMapping', RESEED,@max);
DBCC CHECKIDENT ('SignInUserIDMapping', NORESEED); -- check

alter table dbo.UserSiteEvents drop constraint FK_UserSiteEvents_SiteActivityItems
truncate table dbo.SiteActivityItems -- 450Mb
truncate table dbo.SiteActivityQueue
truncate table dbo.SiteActivityQueueErrors

truncate table dbo.SiteDailySummaryReport
truncate table dbo.SiteKeyPhrases
truncate table dbo.SiteTopicsOpenCloseTimes
truncate table dbo.SNeSActivityQueue
truncate table dbo.SNeSApplicationMetadata
truncate table dbo.Stats_Postings
truncate table dbo.StickyThreads
truncate table dbo.TempUserList
truncate table dbo.TextBoxElements
truncate table dbo.ThreadEditHistory -- 315Mb
truncate table dbo.ThreadEntriesIPAddress -- 11Gb
truncate table dbo.ThreadEntryEditorPicks
truncate table dbo.ThreadEntryRating -- 78Mb
drop view dbo.VThreadKeyphraseCounts
truncate table dbo.ThreadKeyPhrases
alter table dbo.ThreadModHistory drop constraint FK_ThreadModHistory_ThreadMod
truncate table dbo.ThreadMod -- 9.4Gb
truncate table dbo.ThreadModAwaitingEmailVerification
truncate table dbo.ThreadModHistory -- 103Mb
truncate table dbo.ThreadModIPAddress
truncate table dbo.ThreadModReferralsCube
truncate table dbo.ThreadTaglimits
truncate table dbo.ThreadVotes
truncate table dbo.TopicElements
truncate table dbo.Topics
truncate table dbo.UserEventScore
truncate table dbo.UserPostEvents
truncate table dbo.UserPrefStatusAudit
truncate table dbo.UserPrefStatusAuditActions
truncate table dbo.UserReputationScore
truncate table dbo.UserReputationThreshold
truncate table dbo.UserSiteEvents
truncate table dbo.VideoAsset
truncate table dbo.ViewedMovies
truncate table dbo.VoteMembers
truncate table dbo.Votes
truncate table dbo.YourWorldEntries
GO

------------------------------------------------------------------------------------
-- ForumPermissions
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ForumPermissions'), NULL, NULL, 'LIMITED')--'DETAILED')
--start 748Mb
--end 25Mb

DROP INDEX [IX_ForumPermissions] ON [dbo].[ForumPermissions] 
DROP INDEX [IX_ForumPermissions_ForumID] ON [dbo].[ForumPermissions] 

--select * into ForumPermissions_backup from dbo.ForumPermissions

delete from fp
from dbo.ForumPermissions fp
join forums f on f.forumid=fp.forumid
where siteid not in (1,66)
-- 1m 4s

CREATE CLUSTERED INDEX [IX_ForumPermissions] ON [dbo].[ForumPermissions] 
(
	[TeamID] ASC,
	[ForumID] ASC
)

CREATE NONCLUSTERED INDEX [IX_ForumPermissions_ForumID] ON [dbo].[ForumPermissions] 
(
	[ForumID] ASC,
	[TeamID] ASC
)
GO

------------------------------------------------------------------------------------
-- Forums
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('forums'), NULL, NULL, 'LIMITED')--'DETAILED')
-- start 3.616Gb
-- end 174Mb

DROP INDEX [IX_ForumJournalOwner] ON [dbo].[Forums] 
DROP INDEX [IX_Forums_ForumIDSiteID] ON [dbo].[Forums] 
DROP INDEX [IX_Forums_SiteIDLastPosted] ON [dbo].[Forums] 

alter table GuideEntries drop constraint FK_GuideEntries_Forums
alter table RiskModThreadEntryQueue drop constraint FK_RiskModThreadEntryQueue_ForumId
alter table ThreadEntryEditorPicks drop constraint FK_ThreadEntryEditorPicks_Forums
alter table Threads drop constraint FK_Threads_Forums

DROP VIEW VUserPostCount
DROP VIEW VGuideEntryForumPostCount
DROP VIEW VGuideEntryForumLastPosted


declare @n int
set @n=1
while @n > 0
begin
	delete top(10000) from forums
	where siteid not in (1,66)
	set @n=@@rowcount
end
-- 19m

ALTER INDEX PK_Forums ON [dbo].[Forums] REBUILD

ALTER INDEX [IX_ForumsSiteId] ON [dbo].[Forums] REBUILD

CREATE NONCLUSTERED INDEX [IX_ForumJournalOwner] ON [dbo].[Forums] 
(
	[JournalOwner] ASC
)

CREATE NONCLUSTERED INDEX [IX_Forums_ForumIDSiteID] ON [dbo].[Forums] 
(
	[ForumID] ASC,
	[SiteID] ASC
)

CREATE NONCLUSTERED INDEX [IX_Forums_SiteIDLastPosted] ON [dbo].[Forums] 
(
	[SiteID] ASC,
	[LastPosted] ASC
)
GO

------------------------------------------------------------------------
-- ThreadEntries
-- start 101,216,776
-- end 8,626,448
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadEntries'), NULL, NULL, 'LIMITED')

DROP INDEX [IX_ThreadEntries_DatePosted] ON [dbo].[ThreadEntries] 
DROP INDEX [IX_ThreadEntries_Parent] ON [dbo].[ThreadEntries] 
DROP INDEX [IX_ThreadEntries_ThreadPostIndex] ON [dbo].[ThreadEntries] 
DROP INDEX [IX_ThreadUsers] ON [dbo].[ThreadEntries] 

DROP VIEW VUserComments

select distinct te.forumid into #liveforums
from threadentries te
	join forums f on f.forumid=te.forumid
	where f.siteid in (1,66)
create clustered index ix_liveforums on #liveforums(forumid)

select * into ThreadEntriesH2G2 FROM ThreadEntries where 1=0 -- create the new table

SET IDENTITY_INSERT dbo.ThreadEntriesH2G2 ON
declare @n int
select @n=1
while @n > 0
begin
	insert ThreadEntriesH2G2 ([ThreadID],[blobid],[ForumID],[UserID],[Subject],[NextSibling],[Parent],[PrevSibling],[FirstChild],[EntryID],[DatePosted],[UserName],[Hidden],[PostIndex],[PostStyle],[text],[LastUpdated])
	select * from threadentries
	where forumid in (select top(1000) forumid from #liveforums order by forumid)

	;with s as (select top(1000) forumid from #liveforums order by forumid)
	delete s

	set @n=@@rowcount
end
-- 3 hours

SET IDENTITY_INSERT dbo.ThreadEntriesH2G2 OFF

DROP TABLE ThreadEntries
EXEC sp_rename 'ThreadEntriesH2G2', 'ThreadEntries'

ALTER TABLE [dbo].[ThreadEntries] ADD  CONSTRAINT [DF_ThreadEntries_DatePosted]  DEFAULT (getdate()) FOR [DatePosted]
ALTER TABLE [dbo].[ThreadEntries] ADD  CONSTRAINT [DF_ThreadEntries_PostIndex]  DEFAULT ((0)) FOR [PostIndex]

ALTER TABLE [dbo].[ThreadEntries] ADD  CONSTRAINT [PK_ThreadEntries] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)
-- 7m

CREATE NONCLUSTERED INDEX [IX_ThreadEntries_ForumID] ON [dbo].[ThreadEntries] 
(
	[ForumID] ASC
)
INCLUDE ( [ThreadID],
[UserID],
[Parent],
[DatePosted],
[Hidden],
[PostIndex],
[LastUpdated]) 
-- 2m 52s

CREATE NONCLUSTERED INDEX [IX_ThreadEntries_DatePosted] ON [dbo].[ThreadEntries] 
(
	[DatePosted] ASC
)
INCLUDE ( [ForumID],[Hidden])
-- 37s

CREATE NONCLUSTERED INDEX [IX_ThreadEntries_Parent] ON [dbo].[ThreadEntries] 
(
	[Parent] ASC
)
INCLUDE ( [NextSibling],[EntryID]) 
-- 2m 27s

CREATE UNIQUE NONCLUSTERED INDEX [IX_ThreadEntries_ThreadPostIndex] ON [dbo].[ThreadEntries] 
(
	[ThreadID] ASC,
	[PostIndex] ASC
)
INCLUDE ( [DatePosted], [Hidden], [UserID]) 
-- 28s

CREATE NONCLUSTERED INDEX [IX_ThreadUsers] ON [dbo].[ThreadEntries] 
(
	[UserID] ASC
)
INCLUDE ( [ForumID], [DatePosted]) 
-- 29s

GRANT SELECT ON [dbo].[ThreadEntries] TO [ripleyrole]
GO

--------------------------------------------------------------
-- Threads
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Threads'), NULL, NULL, 'LIMITED')
-- start 2,351,768
-- end 154,608

DROP INDEX [IX_Threads_LastUpdated] ON [dbo].[Threads] 
DROP INDEX [IX_Threads_MostRecentThreads] ON [dbo].[Threads] 
DROP INDEX [nci_Threads_ForumID_VisibleTo_Included_Dates_4] ON [dbo].[Threads] 
DROP INDEX [threads0] ON [dbo].[Threads] 

alter table RiskModThreadEntryQueue drop constraint FK_RiskModThreadEntryQueue_Threads
alter table ThreadEntries drop constraint FK_ThreadEntries_Threads

declare @n int
select @n=1
while @n > 0
begin
	delete top (10000) from threads
	where siteid not in (1,66)
	set @n=@@rowcount
end
-- 6m 25s

ALTER INDEX PK_Threads ON Threads REBUILD
ALTER INDEX IX_Threads_SiteIDLastPosted ON Threads REBUILD

CREATE NONCLUSTERED INDEX [IX_Threads_LastUpdated] ON [dbo].[Threads] 
(
	[ForumID] ASC,
	[LastUpdated] ASC
)

CREATE NONCLUSTERED INDEX [IX_Threads_MostRecentThreads] ON [dbo].[Threads] 
(
	[DateCreated] DESC
)
INCLUDE ( [VisibleTo],
[ForumID],
[ThreadID],
[CanRead]) 

CREATE NONCLUSTERED INDEX [nci_Threads_ForumID_VisibleTo_Included_Dates_4] ON [dbo].[Threads] 
(
	[ForumID] ASC,
	[DateCreated] ASC,
	[VisibleTo] ASC
)
INCLUDE ( [ThreadID])

CREATE NONCLUSTERED INDEX [threads0] ON [dbo].[Threads] 
(
	[ForumID] ASC,
	[LastPosted] ASC,
	[VisibleTo] ASC,
	[ThreadID] ASC
)
GO

--------------------------------------------------------------
-- GroupMembers
delete from dbo.GroupMembers where siteid not in (1,66)
-- 24s
GO

--------------------------------------------------------------
-- GuideEntryPermissions

select gep.h2g2id into #gep_h2g2id 
from dbo.GuideEntryPermissions gep
join guideentries ge on ge.h2g2id = gep.h2g2id
where ge.siteid not in (1,66)
create clustered index ix_gep on #gep_h2g2id(h2g2id)

declare @n int
select @n=1
while @n > 0
begin
	delete from GuideEntryPermissions
	where h2g2id in (select top(1000) h2g2id from #gep_h2g2id order by h2g2id)

	;with s as      (select top(1000) h2g2id from #gep_h2g2id order by h2g2id)
	delete s
	set @n=@@rowcount
end
-- 2m 19s
GO

--------------------------------------------------------------
-- GuideEntryVersions

delete gev
from dbo.GuideEntryVersions gev
join guideentries ge on ge.entryid=gev.entryid
where ge.siteid not in (1,66)
-- 28m 18s
GO

--------------------------------------------------------------
-- GuideEntries
-- start 12,385,568
-- end 835,072
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('GuideEntries'), NULL, NULL, 'LIMITED')

alter table ArticleLocation drop constraint FK_ArticleLocation_GuideEntries
alter table ArticleSubscriptions drop constraint FK_ArticleSubscriptions_GuideEntries
alter table Favourites drop constraint FK_Favourites_GuideEntries
alter table GuideEntries drop constraint FK_GuideEntries_GuideEntries1
alter table GuideEntries drop constraint FK_GuideEntries_GuideEntries
alter table Inclusions drop constraint FK_Inclusions_GuideEntries
alter table Inclusions drop constraint FK_Inclusions_GuideEntries1
alter table Researchers drop constraint FK_Researchers_GuideEntries

DROP INDEX [guideentries0] ON [dbo].[GuideEntries] 
DROP INDEX [guideentries2] ON [dbo].[GuideEntries] 
DROP INDEX [IX_GEStatus] ON [dbo].[GuideEntries] 
DROP INDEX [IX_GuideEntriesDateCreated] ON [dbo].[GuideEntries] 
DROP INDEX [IX_GuideEntriesEditor] ON [dbo].[GuideEntries] 
DROP INDEX [IX_GuideEntriesType] ON [dbo].[GuideEntries] 
DROP INDEX [IX_h2g2ID] ON [dbo].[GuideEntries] 

DROP VIEW VUserArticleCount
DROP VIEW VVisibleArticleKeyPhrasesWithDateCreated
DROP VIEW VVisibleArticleKeyPhrasesWithLastUpdated
DROP VIEW VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating
DROP VIEW VVisibleGuideEntries
DROP VIEW VGuideEntryText_memoryshare

select EntryId into #h2g2guideentries from guideentries where siteid in (1,66)
create clustered index ix_h2g2guideentries on #h2g2guideentries(entryid)

select * into GuideEntriesH2G2 FROM GuideEntries where 1=0 -- create the new table

SET IDENTITY_INSERT dbo.GuideEntriesH2G2 ON
declare @n int
select @n=1
while @n > 0
begin
	INSERT INTO GuideEntriesH2G2 (EntryId,[blobid],[DateCreated],[DateExpired],[Cancelled],[SupercededBy],[BasedOn],[Editor],[ForumID],[Subject],[Keywords],[LatestVersion],[Style],[Status],[h2g2ID],[LastUpdated],[Hidden],[SiteID],[Submittable],[ExtraInfo],[Type],[ModerationStatus],[text],[PreProcessed],[CanRead],[CanWrite],[CanChangePermissions])
	select EntryId,[blobid],[DateCreated],[DateExpired],[Cancelled],[SupercededBy],[BasedOn],[Editor],[ForumID],[Subject],[Keywords],[LatestVersion],[Style],[Status],[h2g2ID],[LastUpdated],[Hidden],[SiteID],[Submittable],[ExtraInfo],[Type],[ModerationStatus],[text],[PreProcessed],[CanRead],[CanWrite],[CanChangePermissions] 
	from guideentries
	where Entryid in (select top(1000) entryid from #h2g2guideentries order by EntryId)

	;with s as       (select top(1000) entryid from #h2g2guideentries order by EntryId)
	delete s

	set @n=@@rowcount
end
-- 23m 20s

SET IDENTITY_INSERT dbo.GuideEntriesH2G2 OFF

DROP TABLE GuideEntries
EXEC sp_rename 'GuideEntriesH2G2', 'GuideEntries'

-- A tiny number of guide entries were based on entries from other sites.  Remove these associations so
-- the constraints don't fail
update g1
set basedon=null
from guideentries g1
left join guideentries g2 on g2.entryid=g1.basedon
where g1.basedon is not null and g2.entryid is null

ALTER TABLE [dbo].[GuideEntries] ADD  CONSTRAINT [DF_GuideEntries_Submittable]  DEFAULT (1) FOR [Submittable]
ALTER TABLE [dbo].[GuideEntries] ADD  CONSTRAINT [DF_GuideEntries_SiteID]  DEFAULT (1) FOR [SiteID]
ALTER TABLE [dbo].[GuideEntries] ADD  CONSTRAINT [DF_GuideEntries_PreProcessed]  DEFAULT (1) FOR [PreProcessed]
ALTER TABLE [dbo].[GuideEntries] ADD  CONSTRAINT [DF_GuideEntries_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
ALTER TABLE [dbo].[GuideEntries] ADD  DEFAULT (1) FOR [Type]
ALTER TABLE [dbo].[GuideEntries] ADD  DEFAULT (0) FOR [CanWrite]
ALTER TABLE [dbo].[GuideEntries] ADD  DEFAULT (1) FOR [CanRead]
ALTER TABLE [dbo].[GuideEntries] ADD  DEFAULT (0) FOR [CanChangePermissions]

ALTER TABLE [dbo].[GuideEntries] ADD  CONSTRAINT [PK_GuideEntries] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)

CREATE NONCLUSTERED INDEX [guideentries0] ON [dbo].[GuideEntries] 
(
	[ForumID] ASC,
	[h2g2ID] ASC
)

CREATE NONCLUSTERED INDEX [guideentries2] ON [dbo].[GuideEntries] 
(
	[SiteID] ASC,
	[EntryID] ASC,
	[DateCreated] ASC,
	[Status] ASC,
	[LastUpdated] ASC,
	[Hidden] ASC
)

CREATE NONCLUSTERED INDEX [IX_GEStatus] ON [dbo].[GuideEntries] 
(
	[Status] ASC,
	[h2g2ID] ASC
)

CREATE NONCLUSTERED INDEX [IX_GuideEntriesDateCreated] ON [dbo].[GuideEntries] 
(
	[DateCreated] ASC,
	[SiteID] ASC
)

CREATE NONCLUSTERED INDEX [IX_GuideEntriesEditor] ON [dbo].[GuideEntries] 
(
	[Editor] ASC,
	[Status] ASC,
	[SiteID] ASC,
	[LastUpdated] ASC,
	[Hidden] ASC
)

CREATE NONCLUSTERED INDEX [IX_GuideEntriesType] ON [dbo].[GuideEntries] 
(
	[SiteID] ASC,
	[Type] ASC,
	[Hidden] ASC,
	[Status] ASC
)

CREATE NONCLUSTERED INDEX [IX_h2g2ID] ON [dbo].[GuideEntries] 
(
	[h2g2ID] ASC
)
INCLUDE ( [Editor]) 

GRANT SELECT ON [dbo].[GuideEntries] TO [ripleyrole]
GRANT INSERT ON [dbo].[GuideEntries] TO [ripleyrole]
GRANT UPDATE ON [dbo].[GuideEntries] TO [ripleyrole]
GO

-- GuideEnrty Triggers

CREATE TRIGGER trg_GuideEntries_d ON GuideEntries
FOR DELETE 
AS
	DELETE FROM ArticleIndex
	  FROM ArticleIndex ai
		   INNER JOIN deleted d ON d.EntryID = ai.EntryID

	DELETE FROM ArticleKeyPhrasesNonVisible
	  FROM ArticleKeyPhrasesNonVisible a
			INNER JOIN deleted d ON d.EntryID = a.EntryID

	DELETE FROM ArticleKeyPhrases
	  FROM ArticleKeyPhrases a
			INNER JOIN deleted d ON d.EntryID = a.EntryID
GO
CREATE TRIGGER trg_GuideEntries_i ON GuideEntries
FOR INSERT
AS
	IF NOT UPDATE(LastUpdated)
	BEGIN
		 UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID IN (SELECT EntryID FROM inserted)
	END

	INSERT INTO dbo.ArticleIndex (EntryID, Subject, SortSubject, IndexChar, UserID, Status, SiteID)
	SELECT i.EntryID, 
		   i.Subject, 
		   dbo.udf_removegrammaticalarticlesfromtext (i.Subject), 
		   CASE 
				WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) 
				ELSE '.' END, 
		   m.UserID, 
		   i.Status, 
		   i.SiteID
	  FROM inserted i
			LEFT JOIN Mastheads m on i.EntryID = m.EntryID
	 WHERE i.Status IN (1,3,4) 
	   AND LTRIM(i.Subject) <> '' 
	   AND i.Hidden IS NULL
GO
CREATE TRIGGER trg_GuideEntries_u ON GuideEntries
FOR UPDATE
AS
IF NOT UPDATE(LastUpdated)
BEGIN
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID IN (SELECT EntryID FROM inserted)
END;

WITH EntriesToInsert AS
(
	SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (d.Status NOT IN (1,3,4) OR LTRIM(d.Subject) = '' OR d.Hidden IS NOT NULL)
			AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
) 
INSERT INTO dbo.ArticleIndex (EntryID, Subject, SortSubject, IndexChar, UserID, Status, SiteID)
SELECT eti.EntryID, 
	   eti.Subject, 
	   dbo.udf_removegrammaticalarticlesfromtext (eti.Subject), 
	   CASE 
			WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) 
			ELSE '.' END, 
	   m.UserID, 
	   eti.Status, 
	   eti.SiteID
  FROM EntriesToInsert AS eti
		LEFT JOIN Mastheads m on m.EntryID = eti.EntryID;

WITH EntriesToDelete AS
(
	SELECT i.EntryID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (i.Status NOT IN (1,3,4) OR LTRIM(i.Subject) = '' OR i.Hidden IS NOT NULL)
			AND (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
)
DELETE FROM ArticleIndex
  FROM ArticleIndex ai
	   INNER JOIN EntriesToDelete etd ON etd.EntryID = ai.EntryID;
	   
WITH EntriesToUpdate AS
(
	SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
			AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
)
UPDATE ArticleIndex 
   SET UserID = m.UserID, 
	   Status = etu.Status,
	   SiteID = etu.SiteID
  FROM EntriesToUpdate etu
		LEFT JOIN Mastheads m on etu.EntryID = m.EntryID
 WHERE etu.EntryID = ArticleIndex.EntryID;

IF UPDATE(Subject)
BEGIN;
	WITH EntriesToUpdate AS
	(
		SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
			WHERE (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
				AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
	)
	UPDATE ArticleIndex 
	   SET Subject = etu.Subject, 
		   SortSubject = dbo.udf_removegrammaticalarticlesfromtext (etu.Subject), 
		   IndexChar = CASE 
						WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) 
						ELSE '.' END
	  FROM EntriesToUpdate etu 
	 WHERE etu.EntryID = ArticleIndex.EntryID;
END;

WITH EntriesThatHaveJustBeenMadeNonVisible AS
(
	SELECT	i.EntryID
	  FROM	inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
	 WHERE	(d.Hidden IS NULL AND d.Status != 7) -- Visible
	   AND	(i.Hidden IS NOT NULL OR i.Status = 7) -- Not Visible
)
DELETE FROM dbo.ArticleKeyPhrases 
OUTPUT deleted.SiteID, deleted.EntryID, deleted.PhraseNamespaceID 
INTO dbo.ArticleKeyPhrasesNonVisible (SiteID, EntryID, PhraseNamespaceID)
FROM EntriesThatHaveJustBeenMadeNonVisible
WHERE ArticleKeyPhrases.EntryID = EntriesThatHaveJustBeenMadeNonVisible.EntryID;

WITH EntriesThatHaveJustBeenMadeVisible AS
(
	SELECT	i.EntryID
	  FROM	inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
	 WHERE	(d.Hidden IS NOT NULL OR d.Status = 7) -- Not Visible
	   AND	(i.Hidden IS NULL AND i.Status != 7) -- Visible
)
DELETE FROM dbo.ArticleKeyPhrasesNonVisible
OUTPUT deleted.SiteID, deleted.EntryID, deleted.PhraseNamespaceID 
INTO dbo.ArticleKeyPhrases (SiteID, EntryID, PhraseNamespaceID)
FROM EntriesThatHaveJustBeenMadeVisible
WHERE ArticleKeyPhrasesNonVisible.EntryID = EntriesThatHaveJustBeenMadeVisible.EntryID;
GO

--------------------------------------------------------------
-- Hierarchy
--start 6.6Mb
--end 128Kb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Hierarchy'), NULL, NULL, 'LIMITED')

delete dbo.Hierarchy where siteid not in (1,66)
ALTER INDEX PK_NodeID ON dbo.Hierarchy REBUILD
ALTER INDEX IX_Hierarchy_h2g2id_type ON dbo.Hierarchy REBUILD
ALTER INDEX IX_Hierarchy_ParentID ON dbo.Hierarchy REBUILD

delete ham
from dbo.HierarchyArticleMembers ham
left join Hierarchy h on h.nodeid=ham.nodeid
where h.nodeid is null 
ALTER INDEX IX_HierarchyArticleMembers_EntryID ON dbo.HierarchyArticleMembers REBUILD
ALTER INDEX IX_HierarchyArticleMembers_NodeID ON dbo.HierarchyArticleMembers REBUILD

delete hna
from dbo.HierarchyNodeAlias hna
left join Hierarchy h on h.nodeid=hna.nodeid
left join Hierarchy h2 on h2.nodeid=hna.linknodeid
where h.nodeid is null or h2.nodeid is null 
ALTER INDEX IX_HierarchyNodeAlias_LinkNodeID ON dbo.HierarchyNodeAlias REBUILD

delete htm
from dbo.HierarchyThreadMembers htm
left join Hierarchy h on h.nodeid=htm.nodeid
where h.nodeid is null 
ALTER INDEX UniqueTag ON dbo.HierarchyThreadMembers REBUILD

delete hum
from dbo.HierarchyUserMembers hum
left join Hierarchy h on h.nodeid=hum.nodeid
where h.nodeid is null 
ALTER INDEX IX_HierarchyUserMembers ON dbo.HierarchyUserMembers REBUILD
GO

--------------------------------------------------------------
-- Journals
-- start 275Mb
-- end 13.5Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Journals'), NULL, NULL, 'LIMITED')

DROP INDEX [nci_Journals_ForumID] ON [dbo].[Journals] 

select userid,siteid into #journalsToDelete
from dbo.Journals
where siteid not in (1,66)
create unique clustered index ix_journalsToDelete on #journalsToDelete(userid,siteid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) userid,siteid from #journalsToDelete order by userid,siteid)
	delete from j
	from Journals j
	join toDelete d on d.userid=j.userid and d.siteid=j.siteid

	;with toDelete as (select top(10000) userid,siteid from #journalsToDelete order by userid,siteid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 28s

ALTER INDEX PK_Journals ON [dbo].[Journals] REBUILD

CREATE NONCLUSTERED INDEX [nci_Journals_ForumID] ON [dbo].[Journals] 
(
	[ForumID] ASC
)
GO

--------------------------------------------------------------
-- KeyArticles

delete dbo.KeyArticles where siteid not in (1,66)
ALTER INDEX IX_KeyArticles ON dbo.KeyArticles REBUILD
GO

--------------------------------------------------------------
-- MastHeads
-- start 278Mb
-- end 6Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('MastHeads'), NULL, NULL, 'LIMITED')

DROP INDEX [nci_Mastheads_EntryID] ON [dbo].[Mastheads] 

select userid,siteid into #mastheadsToDelete
from dbo.MastHeads
where siteid not in (1,66)
create unique clustered index ix_mastheadsToDelete on #mastheadsToDelete(userid,siteid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) userid,siteid from #mastheadsToDelete order by userid,siteid)
	delete from m
	from MastHeads m
	join toDelete d on d.userid=m.userid and d.siteid=m.siteid

	;with toDelete as (select top(10000) userid,siteid from #mastheadsToDelete order by userid,siteid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 2s

ALTER TABLE [dbo].[Mastheads] DROP CONSTRAINT [PK_Table_1]
ALTER TABLE [dbo].[Mastheads] ADD  CONSTRAINT PK_Mastheads PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[SiteID] ASC
)

CREATE NONCLUSTERED INDEX [nci_Mastheads_EntryID] ON [dbo].[Mastheads] 
(
	[EntryID] ASC
)
GO

--------------------------------------------------------------
-- ModerationClass

alter table TermsByModClass drop constraint FK_TermsByModClass_ModerationClass
alter table TermsByModClassHistory drop constraint FK_TermsByModClassHistory_ModerationClass
alter table UserEventScore drop constraint FK_UserEventScore_ModerationClass
alter table UserPostEvents drop constraint FK_UserPostEvents_ModerationClass
alter table UserReputationScore drop constraint FK_UserReputationScore_ModerationClass
alter table UserReputationThreshold drop constraint FK_UserReputationThreshold_ModerationClass
alter table UserSiteEvents drop constraint FK_UserSiteEvents_ModerationClass

delete dbo.ModerationClass
where modclassid not in (select modclassid from sites where siteid in (1,66))
GO

--------------------------------------------------------------
-- PostDuplicates
-- start 6.3Gb
-- end 203Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('PostDuplicates'), NULL, NULL, 'LIMITED')--'DETAILED')

select HashValue into #h2g2PostDuplicates from PostDuplicates pd
join forums f on f.forumid=pd.forumid
where f.siteid in (1,66) -- 3m 6s
create clustered index ix_h2g2PostDuplicates on #h2g2PostDuplicates(HashValue)

select * into PostDuplicatesH2G2 FROM PostDuplicates where 1=0 -- create the new table

declare @n int
select @n=1
while @n > 0
begin
	INSERT INTO PostDuplicatesH2G2 ([HashValue],[DatePosted],[ForumID],[ThreadID],[Parent],[UserID],[PostID])
	select *
	from PostDuplicates
	where HashValue in (select top(10000) HashValue from #h2g2PostDuplicates order by HashValue)

	;with s as         (select top(10000) HashValue from #h2g2PostDuplicates order by HashValue)
	delete s

	set @n=@@rowcount
end
-- 24m 29s

DROP TABLE PostDuplicates
EXEC sp_rename 'PostDuplicatesH2G2', 'PostDuplicates'

ALTER TABLE [dbo].[PostDuplicates] ADD  CONSTRAINT [PK_PostDuplicates] PRIMARY KEY CLUSTERED 
(
	[HashValue] ASC,
	[UserID] ASC,
	[ForumID] ASC
)
GO

--------------------------------------------------------------
-- Preferences
-- start 886Mb
-- end 18Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Preferences'), NULL, NULL, 'LIMITED')

DROP INDEX [IX_Preferences_DateJoined] ON [dbo].[Preferences] 
DROP INDEX [IX_Preferences_PrefStatusDuration] ON [dbo].[Preferences] 

select userid,siteid into #PreferencesToDelete
from dbo.Preferences
where siteid not in (1,66)
create unique clustered index ix_PreferencesToDelete on #PreferencesToDelete(userid,siteid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) userid,siteid from #PreferencesToDelete order by userid,siteid)
	delete from p
	from Preferences p
	join toDelete d on d.userid=p.userid and d.siteid=p.siteid

	;with toDelete as (select top(10000) userid,siteid from #PreferencesToDelete order by userid,siteid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 13s

ALTER INDEX IX_Preferences ON dbo.Preferences REBUILD

CREATE NONCLUSTERED INDEX [IX_Preferences_DateJoined] ON [dbo].[Preferences] 
(
	[DateJoined] ASC
)

CREATE NONCLUSTERED INDEX [IX_Preferences_PrefStatusDuration] ON [dbo].[Preferences] 
(
	[PrefStatusDuration] ASC
)
GO

--------------------------------------------------------------
-- Profanities

delete dbo.profanities where modclassid not in (select modclassid from sites where siteid in (1,66))
ALTER INDEX [PK_Profanities] ON dbo.profanities REBUILD
GO

--------------------------------------------------------------
-- Researchers
-- start 224Mb
-- end 6Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Researchers'), NULL, NULL, 'LIMITED')

DROP INDEX IX_Researchers_UserID ON [dbo].Researchers 

select r.entryid,r.userid into #ResearchersToDelete
from dbo.Researchers r
left join guideentries g on g.entryid = r.entryid
where ISNULL(g.siteid,0) not in (1,66)
create clustered index ix_ResearchersToDelete on #ResearchersToDelete(entryid,userid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) entryid,userid from #ResearchersToDelete order by entryid,userid)
	delete from r
	from Researchers r
	join toDelete d on d.entryid=r.entryid and d.userid=r.userid

	;with toDelete as (select top(10000) entryid,userid from #ResearchersToDelete order by entryid,userid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 22s

DROP INDEX IX_Researchers ON [dbo].Researchers 
CREATE CLUSTERED INDEX [IX_Researchers] ON [dbo].[Researchers] 
(
	[EntryID] ASC,
	[UserID] ASC
)

CREATE NONCLUSTERED INDEX [IX_Researchers_UserID] ON [dbo].[Researchers] 
(
	[UserID] ASC,
	[EntryID] ASC
)
GO

-------------------------------------------------------------
-- ReviewForumMembers & ReviewForums

delete from rfm
from dbo.ReviewForumMembers rfm
left join forums f on f.forumid= rfm.forumid
where ISNULL(f.siteid,0) not in (1,66)

ALTER INDEX IX_ReviewForumMembers_ReviewForumID ON dbo.ReviewForumMembers REBUILD
ALTER INDEX IX_ReviewForumMembers_ThreadID ON dbo.ReviewForumMembers REBUILD
ALTER INDEX PK_ReviewFOrumMembers ON dbo.ReviewForumMembers REBUILD

delete from dbo.ReviewForums where siteid not in (1,66)
GO

-------------------------------------------------------------
-- ScoutRecommendations

delete from sr
from dbo.ScoutRecommendations sr
left join guideentries g on g.entryid=sr.entryid
where ISNULL(g.siteid,0) not in (1,66)
GO

-------------------------------------------------------------
-- SiteOptions & Sites & SiteSkins

delete from dbo.SiteOptions where siteid not in (0,1,66)

alter table Forums drop constraint FK_Forums_Sites
alter table SiteActivityItems drop constraint FK_SiteActivityItems_Sites
alter table SiteDailySummaryReport drop constraint FK_SiteDailySummaryReport_Sites
alter table UserSiteEvents drop constraint FK_UserSiteEvents_Sites
delete from dbo.Sites where siteid not in (1,66)

delete from dbo.SiteSkins where siteid not in (1,66)
GO

-------------------------------------------------------------
-- Teams 
-- start 216Mb
-- end 13Mb

--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('Teams'), NULL, NULL, 'LIMITED')

DROP INDEX IX_Team_ForumID ON [dbo].Teams 

select teamid into #TeamsToDelete
from dbo.Teams t 
left join forums f on f.forumid = t.forumid
where ISNULL(f.siteid,0) not in (1,66)
create clustered index ix_TeamsToDelete on #TeamsToDelete(teamid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) teamid from #TeamsToDelete order by teamid)
	delete from t
	from Teams t
	join toDelete d on d.teamid=t.teamid

	;with toDelete as (select top(10000) teamid from #TeamsToDelete order by teamid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 15s

ALTER INDEX PK_Teams ON dbo.Teams REBUILD

CREATE NONCLUSTERED INDEX [IX_Team_ForumID] ON [dbo].[Teams] 
(
	[ForumID] ASC
)
GO

-------------------------------------------------------------
-- TeamMembers 
-- start 506752Mb
-- end 14Mb
--SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
--FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('TeamMembers'), NULL, NULL, 'LIMITED')

DROP INDEX IX_TeamMembers ON [dbo].TeamMembers 

select tm.teamid into #TeamMembersToDelete
from dbo.TeamMembers tm
left join teams t on t.teamid = tm.teamid
where t.teamid is null
create clustered index ix_TeamMembersToDelete on #TeamMembersToDelete(teamid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) teamid from #TeamMembersToDelete order by teamid)
	delete from t
	from TeamMembers t
	join toDelete d on d.teamid=t.teamid

	;with toDelete as (select top(10000) teamid from #TeamMembersToDelete order by teamid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 39s

DROP INDEX [IX_TeamMembers_TeamID] ON [dbo].[TeamMembers] 

CREATE CLUSTERED INDEX [IX_TeamMembers] ON [dbo].[TeamMembers] 
(
	[UserID] ASC,
	[TeamID] ASC
)

CREATE NONCLUSTERED INDEX [IX_TeamMembers_TeamID] ON [dbo].[TeamMembers] 
(
	[TeamID] ASC,
	[UserID] ASC
)
GO

-------------------------------------------------------------
-- Terms tables 

delete from dbo.TermsByModClass where modclassid not in (select modclassid from sites where siteid in (1,66))
delete from dbo.TermsByModClassHistory where modclassid not in (select modclassid from sites where siteid in (1,66))
delete from tuh
from dbo.TermsUpdateHistory tuh
left join TermsByModClassHistory tbmch on tbmch.updateid = tuh.id
where tbmch.updateid is null
GO

-------------------------------------------------------------
-- ThreadPermissions 
delete tp 
from dbo.ThreadPermissions tp
left join threads t on t.threadid=tp.threadid
where ISNULL(t.siteid,0) not in (1,66)
ALTER INDEX IX_ThreadPermissions ON ThreadPermissions REBUILD
GO

-------------------------------------------------------------
-- ThreadPostings
-- start 8Gb
-- end 712Mb
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('ThreadPostings'), NULL, NULL, 'LIMITED')--'DETAILED') 

select tp.ThreadID into #h2g2ThreadPostings 
from ThreadPostings tp
join Threads t on t.threadid=tp.threadid
where t.siteid in (1,66)
create clustered index ix_h2g2ThreadPostings on #h2g2ThreadPostings(threadid)

select * into ThreadPostingsH2G2 FROM ThreadPostings where 1=0 -- create the new table

declare @n int
select @n=1
while @n > 0
begin
	INSERT INTO dbo.ThreadPostingsH2G2 ([UserID],[ThreadID],[LastPosting],[LastUserPosting],[LastUserPostID],[ForumID],[Replies],[CountPosts],[Private],[LastPostCountRead])
	select [UserID],[ThreadID],[LastPosting],[LastUserPosting],[LastUserPostID],[ForumID],[Replies],[CountPosts],[Private],[LastPostCountRead]
	from dbo.[ThreadPostings]
	where ThreadId in (select top(10000) [ThreadID] from #h2g2ThreadPostings order by [ThreadID])

	;with s as       (select top(10000) [ThreadID] from #h2g2ThreadPostings order by [ThreadID])
	delete s

	set @n=@@rowcount
end
-- 17m 22s

DROP TABLE ThreadPostings
EXEC sp_rename 'ThreadPostingsH2G2', 'ThreadPostings'

ALTER TABLE [dbo].[ThreadPostings] ADD  DEFAULT (0) FOR [LastPostCountRead]

CREATE CLUSTERED INDEX [IX_ThreadPostings] ON [dbo].[ThreadPostings] 
(
	[UserID] ASC,
	[ThreadID] ASC
) -- 50s

CREATE NONCLUSTERED INDEX [IX_ThreadPostings2] ON [dbo].[ThreadPostings] 
(
	[ThreadID] ASC
) -- 16s
GO

-------------------------------------------------------------
-- TopFives
delete dbo.TopFives where siteid not in (1,66)
GO

-------------------------------------------------------------
-- UserLastPosted
delete dbo.UserLastPosted where siteid not in (1,66)
ALTER INDEX PK_UserLastPosted ON dbo.UserLastPosted REBUILD
GO

-------------------------------------------------------------
-- Users
-- start 2.3Gb
-- end 48Mb
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('users'), NULL, NULL, 'LIMITED')--'DETAILED') 

DROP INDEX [IX_Journal] ON [dbo].[Users] 
DROP INDEX [IX_Users_Cookie] ON [dbo].[Users] 
DROP INDEX [IX_Users_HashedEmail] ON [dbo].[Users] 
DROP INDEX [IX_Users_TeamID] ON [dbo].[Users] 
DROP INDEX [IX_UsersLoginName] ON [dbo].[Users] 
DROP INDEX [users0] ON [dbo].[Users] 

alter table ArticleModHistory drop constraint FK_ArticleModHistory_LockedBy
alter table ArticleModHistory drop constraint FK_ArticleModHistory_TriggeredBy
alter table ArticleSubscriptions drop constraint FK_ArticleSubscriptionsAuthorId_Users
alter table ArticleSubscriptions drop constraint FK_ArticleSubscriptions_Users
alter table BlockedUserSubscriptions drop constraint FK_BlockedUserSubscriptionsAuthorId_Users
alter table BlockedUserSubscriptions drop constraint FK_BlockedUserSubscriptions_Users
alter table DNASystemMessages drop constraint FK_DNASystemMessages_Users
alter table Favourites drop constraint FK_Favourites_Users
alter table ImageLibrary drop constraint FK_ImageLibrary_Users
alter table Location drop constraint FK_Location_Users
alter table NicknameModHistory drop constraint FK_NicknameModHistory_LockedBy
alter table NicknameModHistory drop constraint FK_NicknameModHistory_TriggeredBy
alter table Researchers drop constraint FK_Researchers_Users
alter table RiskModThreadEntryQueue drop constraint FK_RiskModThreadEntryQueue_Users
alter table Route drop constraint FK_Route_Users
alter table UserPostEvents drop constraint FK_UserPostEvents_Users
alter table UserPrefStatusAudit drop constraint FK_UserPrefStatusAudit_Users
alter table UserReputationScore drop constraint FK_UserReputationScore_Users
alter table UserSiteEvents drop constraint FK_UserSiteEvents_Users
alter table UserSubscriptions drop constraint FK_UserSubscriptionsAuthorId_Users
alter table UserSubscriptions drop constraint FK_UserSubscriptions_Users

select u.userid into #UsersToDelete
from users u
left join preferences p on p.userid=u.userid
where ISNULL(p.siteid,0) not in (1,66)
create unique clustered index ix_UsersToDelete on #UsersToDelete(userid)

declare @n int
select @n=1
while @n > 0
begin
	delete Users 
	where userid in (select top(10000) userid from #UsersToDelete order by userid)

	;with toDelete as (select top(10000) userid from #UsersToDelete order by userid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 5s

UPDATE Users SET EncryptedEmail = NULL, HashedEmail=NULL

ALTER INDEX PK_Users ON [dbo].Users REBUILD

CREATE NONCLUSTERED INDEX [IX_Journal] ON [dbo].[Users] 
(
	[Journal] ASC
)

CREATE NONCLUSTERED INDEX [IX_Users_Cookie] ON [dbo].[Users] 
(
	[Cookie] ASC
)

CREATE NONCLUSTERED INDEX [IX_Users_HashedEmail] ON [dbo].[Users] 
(
	[HashedEmail] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Users_TeamID] ON [dbo].[Users] 
(
	[TeamID] ASC
)

CREATE NONCLUSTERED INDEX [IX_UsersLoginName] ON [dbo].[Users] 
(
	[LoginName] ASC
)

CREATE NONCLUSTERED INDEX [users0] ON [dbo].[Users] 
(
	[Masthead] ASC,
	[UserID] ASC
)
GO

-------------------------------------------------------------
-- UserTeams
-- start 275Mb
-- end 13Mb
SELECT count(*) num_objects,sum(page_count)*8 size_kb,avg(avg_fragmentation_in_percent) avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (db_id('NewGuide'),  OBJECT_ID('UserTeams'), NULL, NULL, 'LIMITED')--'DETAILED') 

DROP INDEX [nci_UserTeams_TeamID] ON [dbo].[UserTeams] 

select userid,siteid into #UserTeamsToDelete
from UserTeams ut
where ut.siteid not in (1,66)
create unique clustered index ix_UserTeamsToDelete on #UserTeamsToDelete(userid,siteid)

declare @n int
select @n=1
while @n > 0
begin
	;with toDelete as (select top(10000) userid,siteid from #UserTeamsToDelete order by userid,siteid)
	delete ut
	from UserTeams ut
	join toDelete d on d.userid=ut.userid and d.siteid=ut.siteid

	;with toDelete as (select top(10000) userid,siteid from #UserTeamsToDelete order by userid,siteid)
	delete toDelete
	set @n=@@rowcount
end
-- 1m 12s

ALTER INDEX PK_UserTeams ON UserTeams REBUILD

CREATE NONCLUSTERED INDEX [nci_UserTeams_TeamID] ON [dbo].[UserTeams] 
(
	[TeamID] ASC
)
GO

-------------------------------------------------------------
-- ArticleSubscriptions

delete dbo.ArticleSubscriptions
where siteid not in (1,66)
GO

-------------------------------------------------------------
-- Recreate all the foreign key constrains

-- Forums
alter table GuideEntries add constraint FK_GuideEntries_Forums FOREIGN KEY (ForumID) REFERENCES Forums (ForumID)
alter table RiskModThreadEntryQueue add constraint FK_RiskModThreadEntryQueue_ForumId FOREIGN KEY (ForumId) REFERENCES Forums (ForumID)
alter table ThreadEntryEditorPicks add constraint FK_ThreadEntryEditorPicks_Forums FOREIGN KEY (forumId) REFERENCES Forums (ForumID)
alter table Threads add constraint FK_Threads_Forums FOREIGN KEY (ForumID) REFERENCES Forums (ForumID)

-- Threads
alter table RiskModThreadEntryQueue add constraint FK_RiskModThreadEntryQueue_Threads FOREIGN KEY (ThreadId) REFERENCES Threads (ThreadID)
alter table ThreadEntries add constraint FK_ThreadEntries_Threads FOREIGN KEY (ThreadID) REFERENCES Threads (ThreadID)

-- GuideEntries
alter table ArticleLocation add constraint FK_ArticleLocation_GuideEntries FOREIGN KEY (EntryID) REFERENCES GuideEntries (EntryID)
alter table ArticleSubscriptions add constraint FK_ArticleSubscriptions_GuideEntries FOREIGN KEY (EntryId) REFERENCES GuideEntries (EntryID)
alter table Favourites add constraint FK_Favourites_GuideEntries FOREIGN KEY (EntryID) REFERENCES GuideEntries (EntryID)
alter table GuideEntries add constraint FK_GuideEntries_GuideEntries1 FOREIGN KEY (BasedOn) REFERENCES GuideEntries (EntryID)
alter table GuideEntries add constraint FK_GuideEntries_GuideEntries FOREIGN KEY (SupercededBy) REFERENCES GuideEntries (EntryID)
alter table Inclusions add constraint FK_Inclusions_GuideEntries FOREIGN KEY (GuideEntryID) REFERENCES GuideEntries (EntryID)
alter table Inclusions add constraint FK_Inclusions_GuideEntries1 FOREIGN KEY (IncludesEntryID) REFERENCES GuideEntries (EntryID)
alter table Researchers add constraint FK_Researchers_GuideEntries FOREIGN KEY (EntryID) REFERENCES GuideEntries (EntryID)

-- ModerationClass
alter table TermsByModClass add constraint FK_TermsByModClass_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table TermsByModClassHistory add constraint FK_TermsByModClassHistory_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table UserEventScore add constraint FK_UserEventScore_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table UserPostEvents add constraint FK_UserPostEvents_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table UserReputationScore add constraint FK_UserReputationScore_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table UserReputationThreshold add constraint FK_UserReputationThreshold_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)
alter table UserSiteEvents add constraint FK_UserSiteEvents_ModerationClass FOREIGN KEY (modclassid) REFERENCES ModerationClass (ModClassID)

-- ArticleMod
alter table ArticleModHistory add constraint FK_ArticleModHistory_ArticleMod FOREIGN KEY (ModID) REFERENCES ArticleMod (ModID)

-- SiteActivityItems
alter table UserSiteEvents add constraint FK_UserSiteEvents_SiteActivityItems FOREIGN KEY (siteeventid) REFERENCES SiteActivityItems (id)

-- Sites
alter table Forums add constraint FK_Forums_Sites FOREIGN KEY (SiteID) REFERENCES Sites (SiteID)
alter table SiteActivityItems add constraint FK_SiteActivityItems_Sites FOREIGN KEY (siteId) REFERENCES Sites (SiteID)
alter table SiteDailySummaryReport add constraint FK_SiteDailySummaryReport_Sites FOREIGN KEY (SiteId) REFERENCES Sites (SiteID)
alter table UserSiteEvents add constraint FK_UserSiteEvents_Sites FOREIGN KEY (siteid) REFERENCES Sites (SiteID)

-- ThreadMod
alter table ThreadModHistory add constraint FK_ThreadModHistory_ThreadMod FOREIGN KEY (ModID) REFERENCES ThreadMod (ModID)

-- Users
alter table ArticleModHistory add constraint FK_ArticleModHistory_LockedBy FOREIGN KEY (LockedBy) REFERENCES Users (UserID)
alter table ArticleModHistory add constraint FK_ArticleModHistory_TriggeredBy FOREIGN KEY (TriggeredBy) REFERENCES Users (UserID)
alter table ArticleSubscriptions add constraint FK_ArticleSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserID)
alter table ArticleSubscriptions add constraint FK_ArticleSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)
alter table BlockedUserSubscriptions add constraint FK_BlockedUserSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserID)
alter table BlockedUserSubscriptions add constraint FK_BlockedUserSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)
alter table DNASystemMessages add constraint FK_DNASystemMessages_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table Favourites add constraint FK_Favourites_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table ImageLibrary add constraint FK_ImageLibrary_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table Location add constraint FK_Location_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table NicknameModHistory add constraint FK_NicknameModHistory_LockedBy FOREIGN KEY (LockedBy) REFERENCES Users (UserID)
alter table NicknameModHistory add constraint FK_NicknameModHistory_TriggeredBy FOREIGN KEY (TriggeredBy) REFERENCES Users (UserID)
alter table Researchers add constraint FK_Researchers_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table RiskModThreadEntryQueue add constraint FK_RiskModThreadEntryQueue_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)
alter table Route add constraint FK_Route_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)
alter table UserPostEvents add constraint FK_UserPostEvents_Users FOREIGN KEY (userid) REFERENCES Users (UserID)
alter table UserPrefStatusAudit add constraint FK_UserPrefStatusAudit_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)
alter table UserReputationScore add constraint FK_UserReputationScore_Users FOREIGN KEY (userid) REFERENCES Users (UserID)
alter table UserSiteEvents add constraint FK_UserSiteEvents_Users FOREIGN KEY (userid) REFERENCES Users (UserID)
alter table UserSubscriptions add constraint FK_UserSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserID)
alter table UserSubscriptions add constraint FK_UserSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)
GO
------------------------------------------------------------------------
-- Recreate all the indexed views
GO
CREATE VIEW VUserPostCount WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising user's post count per site. 
	*/

	SELECT	UserID, SiteID, COUNT_BIG(*) as 'Total'
	  FROM	dbo.ThreadEntries TE 
			INNER JOIN dbo.Forums F ON F.ForumID = TE.ForumID 
	 GROUP	BY te.UserID, f.SiteID
GO
CREATE UNIQUE CLUSTERED INDEX [IX_VUserPostCount] ON [dbo].[VUserPostCount] 
(
	[UserID], 
	[SiteID]
)
GO
CREATE VIEW VGuideEntryForumPostCount WITH SCHEMABINDING
AS
	SELECT g.EntryID, f.ForumPostCount
	  FROM dbo.GuideEntries g
			INNER JOIN dbo.Forums f on g.forumid = f.forumid
	 WHERE g.hidden is null 
	   AND g.status <>7
GO
CREATE UNIQUE CLUSTERED INDEX IX_VGuideEntryForumPostCount ON VGuideEntryForumPostCount
(
	EntryID,
	ForumPostCount
)
GO
CREATE VIEW VGuideEntryForumLastPosted WITH SCHEMABINDING
AS
    -- Get visible articles with a valid forumlastposted date.
	SELECT g.EntryID, f.LastPosted, CASE WHEN f.ForumPostCount > 0 THEN 1 ELSE 0 END 'HasPosts'
	  FROM dbo.GuideEntries g
			INNER JOIN dbo.Forums f on g.forumid = f.forumid
	 WHERE g.hidden is null AND g.status <>7
GO
CREATE UNIQUE CLUSTERED INDEX IX_VGuideEntryForumLastPosted ON VGuideEntryForumLastPosted
(
	EntryID,
	HasPosts,
	LastPosted
)
GO
CREATE VIEW VUserComments WITH SCHEMABINDING
AS
	SELECT te.userid, te.entryid, te.DatePosted, cf.siteid, cf.uid
		FROM dbo.threadentries te
		INNER JOIN dbo.commentforums cf ON cf.forumid=te.forumid
GO
CREATE UNIQUE CLUSTERED INDEX IX_VUserComments ON VUserComments
(
	userid ASC,
	entryid ASC,
	siteid ASC
)

GO
CREATE INDEX IX_VUserComments_SiteId ON VUserComments
(
	SiteId ASC,
	DatePosted DESC
)
GO
CREATE VIEW VUserArticleCount WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising user's article count per site. 
	*/

	SELECT ge.Editor as 'UserID', ge.SiteID, COUNT_BIG(*) as 'Total'
	  FROM dbo.GuideEntries ge
	 WHERE ge.Type <> 3001
	 GROUP BY ge.Editor, ge.SiteID
GO
CREATE UNIQUE CLUSTERED INDEX [IX_VUserArticleCount] ON [dbo].[VUserArticleCount] 
(
	[UserID], 
	[SiteID]
)
GO
CREATE VIEW VVisibleArticleKeyPhrasesWithDateCreated
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.DateCreated
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001
GO
CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithDateCreated
	ON VVisibleArticleKeyPhrasesWithDateCreated(PhraseNamespaceID,DateCreated DESC,EntryID)
GO
CREATE VIEW VVisibleArticleKeyPhrasesWithLastUpdated
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.LastUpdated
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001
GO
-- No longer default search
--CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithLastUpdated
--	ON VVisibleArticleKeyPhrasesWithLastUpdated(PhraseNamespaceID,LastUpdated DESC,EntryID)
GO
CREATE VIEW VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.LastUpdated,pv.AverageRating
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		INNER JOIN dbo.PageVotes pv ON g.EntryID = pv.itemid/10 and pv.itemtype=1
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001		
GO
/*
CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating
	ON VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating(PhraseNamespaceID,AverageRating DESC,LastUpdated DESC,EntryID)
*/	
GO
CREATE VIEW VVisibleGuideEntries WITH SCHEMABINDING
AS
	SELECT EntryID, 
			blobid, 
			DateCreated, 
			DateExpired, 
			Cancelled, 
			SupercededBy, 
			BasedOn, 
			Editor, 
			ForumID, 
			Subject, 
			Keywords, 
			LatestVersion, 
			Style, 
			Status, 
			h2g2ID, 
			stamp, 
			LastUpdated, 
			Hidden, 
			SiteID, 
			Submittable, 
			ExtraInfo, 
			Type, 
			ModerationStatus, 
			text, 
			PreProcessed, 
			CanRead, 
			CanWrite, 
			CanChangePermissions
	  FROM dbo.GuideEntries
	 WHERE Hidden IS NULL And Status != 7
GO
CREATE VIEW VGuideEntryText_memoryshare WITH SCHEMABINDING
AS
	/* 
		Indexed view materialising GuideEntry id, subject and text for full-text searching. 
		The name of the view maps onto the Site's URLName so decisions about which catalogue to query can be done programatically. 
	*/

	SELECT	ge.EntryID,
			ge.Subject,
			ge.text
	  FROM	dbo.Sites s
			INNER JOIN dbo.GuideEntries ge ON s.SiteID = ge.SiteID
	 WHERE	s.URLName = 'memoryshare'

GO
CREATE UNIQUE CLUSTERED INDEX [IX_VGuideEntryText_memoryshare] ON [dbo].[VGuideEntryText_memoryshare] 
(
	[EntryID]
)
GO
CREATE VIEW VArticleKeyphraseCounts WITH SCHEMABINDING
AS
SELECT akp.siteid,
	kp.phraseID,
	count_big(*) cnt
	FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.PhraseNameSpaces pns ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
		INNER JOIN dbo.KeyPhrases kp ON pns.PhraseId = kp.PhraseId
	WHERE pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
	GROUP BY akp.siteid,kp.phraseID

GO
CREATE UNIQUE CLUSTERED INDEX IX_VArticleKeyphraseCounts ON VArticleKeyphraseCounts
(
	siteid ASC,
	phraseID ASC
)
GO
CREATE VIEW VThreadKeyphraseCounts WITH SCHEMABINDING
AS
SELECT tkp.siteid,
	tkp.phraseID,
	count_big(*) cnt
	FROM dbo.ThreadKeyPhrases tkp
	GROUP BY tkp.siteid,tkp.phraseID

GO
CREATE UNIQUE CLUSTERED INDEX IX_VThreadKeyphraseCounts ON VThreadKeyphraseCounts
(
	siteid ASC,
	phraseID ASC
)
GO

------------------------------------------------------------------------
-- Recreate all the full text indexes

CREATE FULLTEXT CATALOG GuideEntriesCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.GuideEntries(Subject, text) KEY INDEX PK_GuideEntries ON GuideEntriesCat WITH CHANGE_TRACKING AUTO
go

CREATE FULLTEXT CATALOG ThreadEntriesCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.ThreadEntries(text) KEY INDEX PK_ThreadEntries ON ThreadEntriesCat WITH CHANGE_TRACKING AUTO
go

CREATE FULLTEXT CATALOG HierarchyCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.Hierarchy(DisplayName, Synonyms) KEY INDEX PK_NodeID ON HierarchyCat WITH CHANGE_TRACKING AUTO
go

CREATE FULLTEXT CATALOG VGuideEntryText_memoryshareCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.VGuideEntryText_memoryshare(Subject, text) KEY INDEX IX_VGuideEntryText_memoryshare ON VGuideEntryText_memoryshareCat WITH CHANGE_TRACKING AUTO
go

------------------------------------------------------------------------
-- Shrink data files

DBCC SHRINKFILE (TheGuide_Data, 20480);
-- size 53.17Gb, used 17.82Gb
-- 3h 33m
DBCC SHRINKFILE (TheGuide_Data2, 20480);
DBCC SHRINKFILE (TheGuide_Data3, 20480);
DBCC SHRINKFILE (TheGuide_Data4, 20480);
GO
