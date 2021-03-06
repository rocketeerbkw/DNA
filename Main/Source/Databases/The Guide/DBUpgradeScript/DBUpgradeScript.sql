IF DB_NAME() NOT LIKE '%guide%'
BEGIN
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;
	RETURN
END

IF ( DB_NAME() = 'SmallGuide' AND DB_ID('SmallGuideSS') > 0  ) 
BEGIN
	-- Restore SmallGuide DB from SnapShot, cannot restore whilst it has active connections.
	USE MASTER
	ALTER DATABASE SmallGuide SET OFFLINE WITH ROLLBACK IMMEDIATE
	ALTER DATABASE SmallGuide SET ONLINE
	RESTORE DATABASE SmallGuide FROM DATABASE_SNAPSHOT = 'SmallGuideSS'
	PRINT 'Restoring Small Guide From Snapshot.'
	USE SmallGuide
END

/*
	!!!!!!!START OF OUTSIDE TRANSACTION WORK!!!!!!!

	This is preparatory work for a schema change that requires work done outside a transaction. 
*/
IF NOT EXISTS (select 1
			     from dbo.admin_dbchanges
			    where uid = 'jac: 2738FDCC-F31A-430C-9A16-A217FFBA962E')
BEGIN
	IF EXISTS (select 1
			     from sys.fulltext_catalogs c
						INNER JOIN sys.fulltext_indexes i ON c.fulltext_catalog_id = i.fulltext_catalog_id
						INNER JOIN sys.objects o ON i.object_id = o.object_id
			    where o.[name] = 'GuideEntries')
	BEGIN
		-- This work can't be done inside a user transaction. 
		DROP FULLTEXT INDEX ON GuideEntries;
		DROP FULLTEXT CATALOG GuideEntriesCat;
		print '!!!!!!! TODO: If you require full-text searching on GuideEntries you must recreate the full-text indexes. See Ripley/CreateFullTextIndexes2005.sql for scripts !!!!!!!'
	END
END
/*
	!!!!!!!END OF OUTSIDE TRANSACTION WORK!!!!!!!
*/

DECLARE @curerror INT


BEGIN TRANSACTION

/*
  PLEASE NOTE: You must apply the function udf_ischangeapplied
  You also need the new dbu_dosql and the dbu_dosql_old procedures
  which we will check now
*/

if not exists (select * from sys.all_objects sp join sys.all_parameters p on p.object_id = sp.object_id where sp.type = N'P' and sp.name = N'dbu_dosql' and p.name = N'@uid')
BEGIN
RAISERROR ('You must apply the new version of dbu_dosql and the new dbu_dosql_old procedures',16,1)
ROLLBACK TRANSACTION
RETURN
END

if not exists (select * from sys.all_objects sp where sp.type = N'P' and sp.name = N'dbu_dosql_old')
BEGIN
RAISERROR ('You must apply the new version of dbu_dosql and the new dbu_dosql_old procedures',16,1)
ROLLBACK TRANSACTION
RETURN
END

IF dbo.udf_siteoptionexists (0,'ArticleSearch','GeneratePopularPhrases') = 0
BEGIN
EXEC dbu_dosql_old N'exec dbu_createsiteoption 0, ''ArticleSearch'', ''GeneratePopularPhrases'', ''0'' ,1,''Generate Popular Phrases from Search Results.''',
	'Creating SiteOption Generate Popular Phrases', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

IF dbo.udf_tableexists('admin_dbchanges') = 0
BEGIN

EXEC dbu_dosql_old N'CREATE TABLE dbo.admin_dbchanges
	(
	uid nvarchar(256) NOT NULL,
	DateApplied datetime NOT NULL,
	description nvarchar(256) NOT NULL,
	sql nvarchar(max) NOT NULL
	)  ON [PRIMARY]',
	'Creating admin changes table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
EXEC dbu_dosql_old N'ALTER TABLE dbo.admin_dbchanges ADD CONSTRAINT
	PK_admin_changes PRIMARY KEY CLUSTERED 
	(
	uid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]',
	'Applying primary key to admin changes table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END


/********************************************************************************************

The simple rules:
	All database changes must happen through calling dbu_dosql
	Each call to dbu_dosql must supply a unique ID. 
	You could generate a GUID by selecting the next line and using the output:
	print newid()
	Or use your own. Please make sure your description field is descriptive and meaningful

	All this information is saved in the new admin_dbchanges table

	dbu_dosql no longer needs to be wrapped in any conditional code, because the first thing
	it does is check if the uid field already exists in the admin_dbchanges table and skips
	the update if it does.

	If you're lazy, select the following text and execute it to produce a template section
	for a new entry, complete with unique ID

	print 'EXEC dbu_dosql N''' + CAST(newid() as nvarchar(255)) + ''','
	print 'N''--your SQL here'','
	print 'N''*** description ***'', @curerror OUTPUT'
	print 'IF (@curerror <> 0) RETURN'

********************************************************************************************/
-- Here are some examples

EXEC dbu_dosql N'Jim: 3AD00B58-235E-4A17-AAFF-944F79491F83',
N'Create table dbo.jimrandomtable ( fname nvarchar(14) NOT NULL, another int NOT NULL) ON [PRIMARY]',
N'Creating jim''s random table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Jim: 9DF70FF6-6DDD-49AC-AE16-A04DC414442E',
N'drop table dbo.jimrandomtable',
N'Dropping jim''s random table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--------------------------------------------
-- 'FastFreetextSearch site option

EXEC dbu_dosql N'Markn: C2F0B39E-9929-4BA4-9416-DC64A62446C9',
N'exec dbu_createsiteoption 0, ''ArticleSearch'', ''FastFreetextSearch'', ''1'' ,1,''Use the Fast freetext search.  Only articles that have ALL the search terms are returned.  It uses the freetext search engine weightings to order the results by relevance.''',
N'Creating SiteOption FastFreetextSearch', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF ( dbo.udf_indexexists('DynamicLists','PK_DynamicLists') = 0 )
BEGIN
	EXEC dbu_dosql N'MartinR: 762948B2-9868-4770-B897-F4FA2D7ED7BD',
	N'CREATE UNIQUE CLUSTERED INDEX [PK_DynamicLists] ON [dbo].[DynamicLists] 
	(
		[name] ASC
	)'
	, N'Creating unique index on Dynamic List table.( To prevent duplicate names).', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'Jim: 809812D8-E797-4504-879A-CDFA1AEC90A0',
N'CREATE TABLE dbo.ThreadModIPAddress
	(
	ThreadModID int NOT NULL,
	IPAddress varchar(25) NULL,
	BBCUID uniqueidentifier NULL
	)  ON [PRIMARY]
',
N'Create table for storing IP address against thread complaints', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: B5BBC281-517D-4875-9246-9B23561DCB24',
N'ALTER TABLE dbo.ThreadModIPAddress ADD CONSTRAINT
	PK_ThreadModIPAddress PRIMARY KEY CLUSTERED 
	(
	ThreadModID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Adding clustered index to ThreadModIPAddress on ModID', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Jim: 8CD757AC-55DB-441B-BCCD-72FC47BBBEE7',
N'CREATE NONCLUSTERED INDEX IX_ThreadModIPAddress_IP ON dbo.ThreadModIPAddress
	(
	IPAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Add index to ThreadModIPAddress on IPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: 98754913-3FC0-43EE-B9A2-039D00F1EBF9',
N'CREATE NONCLUSTERED INDEX IX_ThreadModIPAddress_BBCUID ON dbo.ThreadModIPAddress
	(
	BBCUID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Added index on BBCUID to ThreadModIPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: A2DA58E1-F5AD-44D7-ACF1-DF7450B06DA6',
N'CREATE TABLE dbo.ArticleModIPAddress
	(
	ArticleModID int NOT NULL,
	IPAddress varchar(25) NULL,
	BBCUID uniqueidentifier NULL
	)  ON [PRIMARY]
',
N'Create table for storing IP address against article complaints', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: 4FF0DB0D-0AB2-4CC2-8D47-8E1470F7E68D',
N'ALTER TABLE dbo.ArticleModIPAddress ADD CONSTRAINT
	PK_ArticleModIPAddress PRIMARY KEY CLUSTERED 
	(
	ArticleModID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Adding clustered index to ArticleModIPAddress on ModID', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: 0A09C434-6456-46D2-96B0-E16EC2A86AC6',
N'CREATE NONCLUSTERED INDEX IX_ArticleModIPAddress_IP ON dbo.ArticleModIPAddress
	(
	IPAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Add index to ArticleModIPAddress on IPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: 3F4F4D83-DA34-446E-8EB8-B4FCFF547037',
N'CREATE NONCLUSTERED INDEX IX_ArticleModIPAddress_BBCUID ON dbo.ArticleModIPAddress
	(
	BBCUID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Added index on BBCUID to ArticleModIPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: FB993DBD-0324-4EAE-9A11-A1BABCDBFA7F',
N'CREATE TABLE dbo.GeneralModIPAddress
	(
	GeneralModID int NOT NULL,
	IPAddress varchar(25) NULL,
	BBCUID uniqueidentifier NULL
	)  ON [PRIMARY]
',
N'Create table for storing IP address against general complaints', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: 82D34D04-21CA-4E54-8203-342B770FC63D',
N'ALTER TABLE dbo.GeneralModIPAddress ADD CONSTRAINT
	PK_GeneralModIPAddress PRIMARY KEY CLUSTERED 
	(
	GeneralModID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Adding clustered index to GeneralModIPAddress on ModID', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: F234BE08-81CE-4F8A-B1C1-79DF8CC6BE62',
N'CREATE NONCLUSTERED INDEX IX_GeneralModIPAddress_IP ON dbo.GeneralModIPAddress
	(
	IPAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Add index to GeneralModIPAddress on IPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: DA7A67DE-DFBC-4FA0-9A26-862606902FFB',
N'CREATE NONCLUSTERED INDEX IX_GeneralModIPAddress_BBCUID ON dbo.GeneralModIPAddress
	(
	BBCUID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Added index on BBCUID to GeneralModIPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN


--------------------------------------------
-- 'Include Comments in Personal Space site option

EXEC dbu_dosql N'Steve: 77975756-1F52-4ee9-8AE0-B61F6281BCB6',
N'exec dbu_createsiteoption 0, ''PersonalSpace'', ''IncludeRecentComments'', ''0'', 1, ''Set if user comments are to be included in personal spaces.''',
N'Creating SiteOption IncludeRecentComments in PersonalSpace', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--------------------------------------------
-- 'Change ContentSignifArticle so it keys off EntryID

EXEC dbu_dosql N'jac: 4B4C606F-A057-4192-A146-5D82AD9DF0B9', 
N'SELECT * INTO #ContentSignifArticle FROM dbo.ContentSignifArticle; 
DROP TABLE ContentSignifArticle;

CREATE TABLE [dbo].[ContentSignifArticle](
	[EntryID] [int] NOT NULL,
	[Score] [float] NOT NULL,
	[SiteID] [int] NOT NULL,
	[ScoreLastIncrement] [datetime] NOT NULL,
	[ScoreLastDecrement] [datetime] NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_ContentSignifArticle] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

INSERT INTO ContentSignifArticle
SELECT ge.EntryID, csa.Score, csa.SiteID, csa.ScoreLastIncrement, csa.ScoreLastDecrement, csa.DateCreated
  FROM #ContentSignifArticle csa
		INNER JOIN GuideEntries ge ON csa.h2g2ID = ge.h2g2ID;',
N'Change ContentSignifArticle so it keys off EntryID', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--------------------------------------------
-- 'Change NameSpace indexes. 

EXEC dbu_dosql N'jac: E3232754-E0E7-42A4-997C-C563F980B271', 
N'ALTER TABLE [dbo].[NameSpaces] DROP CONSTRAINT [PK_Namespaces]; 

ALTER TABLE [dbo].[NameSpaces] ADD  CONSTRAINT [PK_Namespaces] PRIMARY KEY CLUSTERED 
(
	[NameSpaceID] ASC
)',
N'Change NameSpace Primary Key.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

/*
 * This sql is wrong but completed on SmallGuide and locally on DBs due to schema inconsistencies. 
 * The solution to correct DB schema and make admin_dbchanges consistent across DBs is :
 * 1. Comment out this code so it is never run.
 * 2. Correct the sql so index exists check is correct and the erroneous index is dropped See UID 'jac: B02C685E-9B5F-42ED-895B-4C519848390F' below. 
 * 3. Manually remove UID 'jac: 5BE5A666-C60E-4A27-A14E-3465A1B052B0' from admin_dbchanges so table is consistent across DBs (delete from dbo.admin_dbchanges where uid = 'jac: 5BE5A666-C60E-4A27-A14E-3465A1B052B0')
 * 
EXEC dbu_dosql N'jac: 5BE5A666-C60E-4A27-A14E-3465A1B052B0', 
N'IF dbo.udf_indexexists (''Namespaces'', ''IX_NameSapces_Name'') = 0
BEGIN
	DROP INDEX [IX_NameSapces_Name] ON [dbo].[NameSpaces]
END', 
N'Drop index IX_NameSapces_Name from Namespace table if it exists.', @curerror OUTPUT
IF (@curerror <> 0) RETURN
 *
 *
 */

EXEC dbu_dosql N'jac: C8A42A02-B637-49A5-BC0F-86BCD78BE128', 
N'CREATE UNIQUE NONCLUSTERED INDEX [IX_NameSpaces_SiteIDName] ON [dbo].[NameSpaces] 
(
	[SiteID] ASC,
	[Name] ASC
)',
N'Create unique clustered index IX_NameSpaces_SiteIDName on Namespaces.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: B02C685E-9B5F-42ED-895B-4C519848390F', 
N'IF dbo.udf_indexexists (''Namespaces'', ''IX_NameSapces_Name'') = 1
BEGIN
	DROP INDEX [IX_NameSapces_Name] ON [dbo].[NameSpaces]
END', 
N'Drop index IX_NameSapces_Name from Namespace table if it exists.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: F34F534C-AF74-472A-964C-7BE3F1952CC5', 
N'IF dbo.udf_indexexists (''Namespaces'', ''IX_NameSapces_NameSiteID'') = 1
BEGIN
	DROP INDEX [IX_NameSapces_NameSiteID] ON [dbo].[NameSpaces]
END', 
N'Drop index IX_NameSapces_NameSiteID from Namespace table if it exists.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'mrh: 6D1F287A-B14B-47A6-ADC4-AFCF5552C6EC', 
N'INSERT INTO dbo.SiteOptions SELECT Section = ''KeyPhrases'', SiteID = 0, Name = ''DelimiterToken'', Value = '' '', Type = 2, Description = ''The character you want to use to delimit phrases. i.e. " " (Space)''', 
N'Insert new Delimiting character site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 62E0F68E-632F-4742-9B5E-00DB80A0A798', 
N'GRANT SELECT ON ContentSignifArticle TO ripleyrole',
N'Grant select on ContentSignifArticle to ripleyrole', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jim: 38DAABE4-10CA-4CF5-8B54-06BEBA3DAA51',
N'EXECUTE sp_rename N''dbo.PreModPostings.IgnoreThreadPostings'', N''IsComment'', ''COLUMN''',
N'Renaming IgnoreThreadPostings column to IsComment', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jim: 87039182-09E2-49DD-AB2C-4E67AA763383',
N'EXECUTE sp_rename N''dbo.PostingQueue.IgnoreThreadPostings'', N''IsComment'', ''COLUMN''',
N'Renaming PostingQueue.IgnoreThreadPostings to IsComment', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'mrh: 6D1F387A-B13B-43A6-A3C4-AF3F5532C63C',
	N'CREATE TABLE dbo.BannedEmails
	(
		Email varchar(256) NOT NULL,
		DateAdded datetime NOT NULL,
		EditorID int NOT NULL
	) ON [PRIMARY]
',
N'Create new BannedEmails Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--------------------------------------------
-- Indexes for CommentForums 

EXEC dbu_dosql N'markn: D0668A38-CEFB-4DC7-B021-C2C55A031DC9',
N'CREATE CLUSTERED INDEX [IX_CommentForums] ON [dbo].[CommentForums] (ForumID)
  CREATE NONCLUSTERED INDEX [IX_CommentForums_Url] ON [dbo].[CommentForums] (Url)
  CREATE UNIQUE NONCLUSTERED INDEX [IX_CommentForums_UID] ON [dbo].[CommentForums] (UID)',
N'Indexes for CommentForums', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 2738FDCC-F31A-430C-9A16-A217FFBA962E',
N'DROP VIEW VVisibleGuideEntries; 

ALTER TABLE dbo.GuideEntries ALTER COLUMN text VARCHAR(MAX);',
N'!!!!!!! TODO : You will need to re-create VVisibleGuideEntries from your views project after altering GuideEntries column text to varchar(max) !!!!!!!', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 569F427E-746D-4345-B07B-892E72F3089A',
N'ALTER INDEX PK_GuideEntries ON GuideEntries REBUILD;',
N'Rebuild PK_GuideEntries on GuideEntries.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 2738FDCC-F31A-430C-9A16-A217FFBA962E',
N'DROP VIEW VVisibleGuideEntries; 

ALTER TABLE dbo.GuideEntries ALTER COLUMN text VARCHAR(MAX);',
N'!!!!!!! TODO : You will need to re-create VVisibleGuideEntries from your views project after altering GuideEntries column text to varchar(max) !!!!!!!', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 569F427E-746D-4345-B07B-892E72F3089A',
N'ALTER INDEX PK_GuideEntries ON GuideEntries REBUILD;',
N'Rebuild PK_GuideEntries on GuideEntries.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 20758AC5-9228-436E-82BB-90C9E237C44F', 
N'IF (dbo.udf_viewexists(''VVisibleGuideEntries'') = 0)
BEGIN
	EXEC sp_executesql N''CREATE VIEW VVisibleGuideEntries WITH SCHEMABINDING
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
		 WHERE Hidden IS NULL And Status != 7;''
END',
N'If view VVisibleGuideEntries does not exist re-create it so DBUpgradeScript release 3.0.5 to 3.0.7 can run in it''s entirety.', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'jac: 1E4A5DFA-0159-4744-A5D9-875AF4379928',
N'SET NOCOUNT ON 
delete from dbo.Nums; 

DECLARE @i INT;
SET @i = 1;
WHILE (@i <= 8000)
BEGIN 
	INSERT INTO dbo.Nums (n) VALUES (@i);
	SET @i = @i + 1;
END;
SET NOCOUNT OFF',
N'Populating Nums table.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 4F590997-D00E-4B90-84A4-20270217D7C2',
N'CREATE TABLE [dbo].[ArticleKeyPhrasesNonVisible](
	[SiteID] [int] NOT NULL,
	[EntryID] [int] NOT NULL,
	[PhraseNamespaceID] [int] NOT NULL
) ON [PRIMARY]',
N'Create table ArticleKeyPhrasesNonVisible', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: CA65880E-0D5F-4C98-ACD3-7959E1CA9C1D',
N'CREATE UNIQUE CLUSTERED INDEX [IX_ArticleKeyPhrasesNonVisible] ON [dbo].[ArticleKeyPhrasesNonVisible] 
(
	[SiteID] ASC,
	[PhraseNamespaceID] ASC,
	[EntryID] ASC
)',
N'CREATE UNIQUE CLUSTERED INDEX IX_ArticleKeyPhrasesNonVisible', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 805DA634-632E-48B7-9CB2-45FEAA04F5B7',
N'CREATE NONCLUSTERED INDEX [IX_ArticleKeyPhrasesNonVisible_EntryID] ON [dbo].[ArticleKeyPhrasesNonVisible] 
(
	[EntryID] ASC
)',
N'CREATE NONCLUSTERED INDEX [IX_ArticleKeyPhrasesNonVisible_EntryID]', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: DCF4BEB6-2184-4C3D-8395-2F346584B81A',
N'CREATE NONCLUSTERED INDEX [IX_ArticleKeyPhrasesNonVisible_PhraseNamespaceID] ON [dbo].[ArticleKeyPhrasesNonVisible] 
(
	[PhraseNamespaceID] ASC
)',
N'CREATE NONCLUSTERED INDEX [IX_ArticleKeyPhrasesNonVisible_PhraseNamespaceID]', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: EF2625FC-35C1-45A9-8CE1-9322EC971AF6',
N'DECLARE @DuplicateMediaAssets TABLE (MediaAssetID INT NOT NULL);

INSERT INTO @DuplicateMediaAssets (MediaAssetID) 
SELECT MediaAssetID
  FROM dbo.ArticleMediaAsset ama1
 WHERE MediaAssetID NOT IN (SELECT MIN(MediaAssetID)
						      FROM dbo.ArticleMediaAsset ama2
						     WHERE ama1.EntryID = ama2.EntryID);

DELETE FROM dbo.MediaAsset
  FROM @DuplicateMediaAssets dma
 WHERE dma.MediaAssetID = MediaAsset.ID;

DELETE FROM dbo.ArticleMediaAsset
  FROM @DuplicateMediaAssets dma
 WHERE dma.MediaAssetID = ArticleMediaAsset.MediaAssetID;

DELETE FROM dbo.MediaAssetMod
  FROM @DuplicateMediaAssets dma
 WHERE dma.MediaAssetID = MediaAssetMod.MediaAssetID;

DELETE FROM dbo.MediaAssetLibrary
  FROM @DuplicateMediaAssets dma
 WHERE dma.MediaAssetID = MediaAssetLibrary.MediaAssetID;

DELETE FROM dbo.MediaAssetIPAddress
  FROM @DuplicateMediaAssets dma
 WHERE dma.MediaAssetID = MediaAssetIPAddress.MediaAssetID;',
N'Delete all but the first MediaAsset associated with an article (an article should only have 1 media asset associated with it).', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: B25752F4-3C8B-4487-9CB3-7DB6C2D82245',
N'WITH VisibleGuideEntriesThatHaveHiddenMediaAssets AS
(
	select vge.EntryID
	  from VVisibleGuideEntries vge
			INNER JOIN dbo.ArticleMediaAsset ama ON vge.EntryID = ama.EntryID
			INNER JOIN dbo.MediaAsset ma ON ama.MediaAssetID = ma.ID
	 where ma.Hidden IS NOT NULL
)
UPDATE VVisibleGuideEntries
   SET Hidden = 1
 WHERE EntryID IN (SELECT EntryID FROM VisibleGuideEntriesThatHaveHiddenMediaAssets);',
N'Hide GuideEntries with hidden MediaAssets. ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 310E84BA-B7F9-4FB3-B34E-CB8E0B751BE3',
N'WITH HiddenGuideEntriesThatHaveVisibleMediaAssets AS
(
	select ma.ID
	  from dbo.GuideEntries ge 
			INNER JOIN dbo.ArticleMediaAsset ama ON ge.EntryID = ama.EntryID
			INNER JOIN dbo.MediaAsset ma ON ama.MediaAssetID = ma.ID
	 where ge.Hidden is not null
	   and ma.Hidden is null
)
UPDATE MediaAsset
   SET Hidden = 1
 WHERE ID IN (SELECT ID FROM HiddenGuideEntriesThatHaveVisibleMediaAssets);',
N'Hide MediaAssets associated with hidden GuideEntries. ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 8EC73B5B-BBAD-4A9D-BBFA-52A14A586DBF',
N'WITH GuideEntryMediaAssetMismatchedSiteID AS
(
	SELECT va.MediaAssetID, ge.SiteID
	  FROM dbo.VArticleVideoAssets va
			INNER JOIN dbo.GuideEntries ge on va.EntryID = ge.EntryID
	 WHERE va.SiteID <> ge.SiteID	
)
UPDATE MediaAsset
   SET SiteID = u.SiteID
  FROM GuideEntryMediaAssetMismatchedSiteID u
 WHERE u.MediaAssetID = MediaAsset.ID;',
N'Match up SiteIDs on GuideEntries and MediaAssets. Mismatch on dev/release servers only.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--------------------------------------------
-- 'Article Search Cache Time site option

EXEC dbu_dosql N'Steve: 7CAD30E5-9AAA-4d15-969F-CBB68BE4FB00',
N'exec dbu_createsiteoption 0, ''ArticleSearch'', ''CacheTime'', ''10'', 0, ''Sets the length of time in minutes that article searches are cached for.''',
N'Creating SiteOption CacheTime in ArticleSearch', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 24291F75-0417-4E29-9CDA-35CB79AF0B98',
N'WITH MemoryShareArticlesWithADateRangeGreaterThan1Day AS
(
	SELECT adr.EntryID
	  FROM dbo.GuideEntries ge
			INNER JOIN dbo.ArticleDateRange adr ON ge.EntryID = adr.EntryID
			INNER JOIN dbo.Sites s ON ge.SiteID = s.SiteID
	 WHERE DATEDIFF(dd, adr.StartDate, adr.EndDate) > 1
	   AND s.URLName = ''memoryshare''
)
UPDATE dbo.ArticleDateRange
   SET EndDate = dateadd(dd, 1, EndDate)
  FROM MemoryShareArticlesWithADateRangeGreaterThan1Day a
 WHERE ArticleDateRange.EntryID = a.EntryID;',
N'Add 24 hours to date ranges in MemoryShare > 1 day.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 735F3F28-3CC6-4D18-9E23-864E5A66F93B',
N'WITH MemoryShareArticlesWithSpecificDateRangeOf1Day AS
(
	SELECT adr.EntryID
	  FROM dbo.GuideEntries ge
			INNER JOIN dbo.ArticleDateRange adr ON ge.EntryID = adr.EntryID
			INNER JOIN dbo.Sites s ON ge.SiteID = s.SiteID
	 WHERE DATEDIFF(dd, adr.StartDate, adr.EndDate) = 1
	   AND adr.TimeInterval is null
	   AND s.URLName = ''memoryshare''
)
UPDATE dbo.ArticleDateRange
   SET EndDate = dateadd(dd, 1, EndDate)
  FROM MemoryShareArticlesWithSpecificDateRangeOf1Day a
 WHERE ArticleDateRange.EntryID = a.EntryID;',
N'Add 24 hours to specific date ranges of 1 day in MemoryShare.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 59B6ED46-4204-4A6E-8238-1BC622D28835',
N'exec dbu_createsiteoption 0, ''GuideEntries'', ''InclusiveDateRange'', ''1'', 1, ''Set to true user inputted date range is inclusive. e.g. if user input 01/09/1975 - 02/09/1975 then they mean 2 days 01/09/1975 00:00 to 03/09/1975 00:00''',
N'Creating SiteOption InclusiveDateRange', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: CC8464A1-6DE8-401E-9E7A-05EBFBA604A5',
N'UPDATE dbo.ArticleDateRange
   SET EndDate = DATEADD(mi, -1, EndDate)
 WHERE DATEPART(mi, EndDate) = 0;',
N'Take 1 minute off all end dates so dates are of the form <date> 00:00 <date> 23:59.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: BD3211C3-DECC-463B-BA15-D9629C0D51FF',
N'UPDATE dbo.ArticleDateRange
   SET EndDate = DATEADD(mi, 1, EndDate)
 WHERE DATEPART(mi, EndDate) = 59;',
N'Add 1 minute to all end dates ending mi = 59 so end date represents the first instance outside the range.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: B480A6F5-90EB-4C8C-B067-3417BD5E6DEB',
N'WITH GuideEntriesWithKeyPhrasesThatAreNonVisible AS
(
	SELECT ge.EntryID
	  FROM dbo.GuideEntries ge
			INNER JOIN dbo.ArticleKeyPhrases akp ON ge.EntryID = akp.EntryID
	 WHERE ge.Hidden IS NOT NULL OR ge.Status = 7
)
DELETE FROM dbo.ArticleKeyPhrases 
OUTPUT deleted.SiteID, deleted.EntryID, deleted.PhraseNamespaceID 
INTO dbo.ArticleKeyPhrasesNonVisible (SiteID, EntryID, PhraseNamespaceID)
FROM GuideEntriesWithKeyPhrasesThatAreNonVisible
WHERE ArticleKeyPhrases.EntryID = GuideEntriesWithKeyPhrasesThatAreNonVisible.EntryID;',
N'Move the KeyPhrases of non visible GuideEntries into ArticleKeyPhrasesNonVisible.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Code to add stuff to SmallGuide that was missed
IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'Steve: 0B055566-EEC4-4FC3-9D37-85A8EE723000',
	N'INSERT INTO Userstatuses ( UserStatusID, UserStatusDescription) VALUES
	(0,	''Standard'')
	INSERT INTO Userstatuses ( UserStatusID, UserStatusDescription) VALUES
	(1,	''Premoderate'')
	INSERT INTO Userstatuses ( UserStatusID, UserStatusDescription) VALUES
	(2,	''Postmoderate'')
	INSERT INTO Userstatuses ( UserStatusID, UserStatusDescription) VALUES
	(3,	''Send for review'')
	INSERT INTO Userstatuses ( UserStatusID, UserStatusDescription) VALUES
	(4,	''Banned'')',
	N'Adding UserStatus table into Small Guide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Jim: F88F1C13-7369-403C-B61E-B4E5E72D9877',
N'UPDATE Sites SET SSOService = UrlName',
N'Populating smallguide with SSOService name', @curerror OUTPUT
IF (@curerror <> 0) RETURN
END

--Add an  article key phrases site option.
EXEC dbu_dosql N'MartinR: 07D4C99B-A4C6-44c4-B877-A03836F30DA7',
	N'exec dbu_createsiteoption 0, ''General'', ''ArticleKeyPhrases'', ''0'' ,1,''Set if site has articles with key phrases.''',
	N'Creating SiteOption ArticleKeyPhrases', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

--Rename existing KeyPhrases siteoption to ThreadKeyPhrases as it refers to Thread Key Phrases only. 
EXEC dbu_dosql N'MartinR: 5544EC70-D4CF-4155-B6B7-2E632A21C7BD',
	N'UPDATE SiteOptions SET Name=''ThreadKeyPhrases'', Description=''Set if site has threads with key phrases'' WHERE Name=''KeyPhrases'' AND Section=''General''',
	N'Renaming KeyPhrases SiteOption', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

--Create UserSubscriptions Table
EXEC dbu_dosql N'MartinR: F6274516-301E-45c2-BF34-46AA20ED058A',
N'CREATE TABLE dbo.UserSubscriptions
	(
	UserId INT NOT NULL,
	AuthorId INT NOT NULL,
	)  ON [PRIMARY]',
	N'Creating user subscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
EXEC dbu_dosql N'MartinR: 739A0ED4-F5C8-4e83-873D-E5FCDB4C8B77',
	N'ALTER TABLE dbo.usersubscriptions ADD CONSTRAINT
	PK_usersubscriptions PRIMARY KEY CLUSTERED 
	(
	 Userid, Authorid 
	) ON [PRIMARY]',
	N'Applying primary key to usersubscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

--Add Foreign Keys to User Subscriptions
EXEC dbu_dosql  N'MartinR: 32F7F8A5-07A7-48c7-A724-244890BC2597',
	N'ALTER TABLE UserSubscriptions ADD CONSTRAINT FK_UserSubscriptions_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)',
	N'Adding Foreign Key FK_UserSubscriptions_Users',@curerror OUTPUT
	IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: 8715B836-3781-44fa-8D3B-B6E67858EF66',
	N'ALTER TABLE UserSubscriptions ADD CONSTRAINT FK_UserSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserId)',
	N'Adding Foreign Key FK_UserSubscriptionsAuthorId_Users',@curerror OUTPUT
	IF ( @curerror <> 0 ) RETURN

--Create table ArticleSubscriptions
EXEC dbu_dosql N'MartinR: 2D18308F-83F9-4534-B4D4-B5729F9D422D',
	N'CREATE TABLE dbo.ArticleSubscriptions
	(
	UserId INT NOT NULL,
	AuthorId INT NOT NULL,
	EntryId INT NOT NULL,
	DateCreated DATETIME NOT NULL,
	SiteId INT NOT NULL,
	CONSTRAINT FK_ArticleSubscriptions_UserSubscriptions FOREIGN KEY (UserId, AuthorId) 
	REFERENCES UserSubscriptions ( UserId, AuthorId)
	ON UPDATE NO ACTION ON DELETE CASCADE 
	)  ON [PRIMARY]',
	N'Creating Article Subscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
EXEC dbu_dosql  N'MartinR: 9C57202C-67B6-49c1-9627-6E2DA5C7A5B7',
	N'ALTER TABLE dbo.ArticleSubscriptions ADD CONSTRAINT
	PK_articlesubscriptions PRIMARY KEY CLUSTERED 
	(
	 userid, authorid, entryid
	) ON [PRIMARY]',
	N'Applying primary key to articlesubscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

--Add Foreign Key Constraints to ArticleSubscriptions
EXEC dbu_dosql N'MartinR : D862A6EA-C27F-4ee1-8C68-B3B83EB0BE95',
	N'ALTER TABLE ArticleSubscriptions ADD CONSTRAINT FK_ArticleSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)',
	N'Adding Foreign Key Constraint FK_ArticleSubscriptions_Users', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 621D3690-FC26-4aad-A359-FA5F95B457BC',
	N'ALTER TABLE ArticleSubscriptions ADD CONSTRAINT FK_ArticleSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserID)',
	N'Adding Foreign Key Constraint FK_ArticleSubscriptionsAuthorId_Users', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 9034A8CC-4C02-46ac-BC29-102B8C973B42',
	N'ALTER TABLE ArticleSubscriptions ADD CONSTRAINT FK_ArticleSubscriptions_GuideEntries FOREIGN KEY (EntryId) REFERENCES GuideEntries (EntryID)',
	N'Adding Foreign Key Constraint FK_ArticleSubscriptions_GuideEntries', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Create BlockedUserSubscriptions table.
EXEC dbu_dosql N'MartinR: 0F058AB7-A2A1-4c05-A28D-720507335492',
	N'CREATE TABLE dbo.BlockedUserSubscriptions
	(
	UserId INT NOT NULL,
	AuthorId INT NOT NULL,
	)  ON [PRIMARY]',
	N'Creating BlockedUserSubscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
EXEC dbu_dosql N'MartinR: D1B76231-B3E6-482c-8D9B-862481A200A3',
	N'ALTER TABLE dbo.BlockedUserSubscriptions ADD CONSTRAINT
	PK_blockedsubscriptions PRIMARY KEY CLUSTERED 
	(
	 Userid, Authorid 
	)  ON [PRIMARY]',
	N'Applying primary key to blockedsubscriptions table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

--Add Foreign Keys to BlockedUserSubscriptions
EXEC dbu_dosql N'MartinR: 1388C606-7FD1-45f6-8AD0-1F514754F402',
	N'ALTER TABLE BlockedUserSubscriptions ADD CONSTRAINT FK_BlockedUserSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users (UserID)',
	N'Adding foreign key constraint FK_BlockedUserSubscriptions_Users',
@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 54BB526D-5F5C-4799-9063-14DA6240834F',
	N'ALTER TABLE BlockedUserSubscriptions ADD CONSTRAINT FK_BlockedUserSubscriptionsAuthorId_Users FOREIGN KEY (AuthorId) REFERENCES Users (UserId)',
	N'Adding foreign key constraint FK_BlockedUserSubscriptionsAuthorId_Users',
@curerror OUTPUT
IF (@curerror <> 0) RETURN

--Add AcceptSubscrtions to User Table.
EXEC dbu_dosql N'MartinR: 21E27768-5AE9-4470-80C3-B8CA94133610',
	N'ALTER TABLE dbo.Users ADD AcceptSubscriptions bit NOT NULL CONSTRAINT DF_Users_AcceptSubscriptions DEFAULT 1', 'Adding AcceptSubscriptions Column to Users Table', 
	@curerror OUTPUT
IF (@curerror <> 0) RETURN


-- Code to add stuff to SmallGuide that was missed
IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'SteveF: 49A91535-F2AC-4d05-AF1F-D7DFA0CB1883',
N'INSERT INTO SmallGuide.dbo.ContentSignifAction
  SELECT *
    FROM TheGuide.dbo.ContentSignifAction

INSERT INTO SmallGuide.dbo.ContentSignifDecrement
  SELECT *
    FROM TheGuide.dbo.ContentSignifDecrement

INSERT INTO SmallGuide.dbo.ContentSignifIncrement
  SELECT *
    FROM TheGuide.dbo.ContentSignifIncrement

INSERT INTO SmallGuide.dbo.ContentSignifItem
  SELECT *
    FROM TheGuide.dbo.ContentSignifItem

INSERT INTO SmallGuide.dbo.ContentSignifUser
  SELECT *
    FROM TheGuide.dbo.ContentSignifUser tgu where tgu.userid=6',
N'Creating contentsignif tables on smallguide'
, @curerror OUTPUT
IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MarkH: 1C03F7CFC-B11D-4037-84E2-6367F9E030A5',
	N'ALTER TABLE dbo.BannedEmails ADD CONSTRAINT PK_BannedEmails PRIMARY KEY CLUSTERED (Email)',
	N'Adding primary key to the bannedemails table',
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 4E21B962-713C-405D-A88B-E48FD8D63E39',
	N'IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[BannedEmails]'') AND name = N''PK_BannedEmails'')
	ALTER TABLE [dbo].[BannedEmails] DROP CONSTRAINT [PK_BannedEmails]',
	N'dropping clustered primary key on bannedemails table',
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 2C23F2C2C-B11D-4037-84E2-6367F9E030A5',
	N'ALTER TABLE dbo.BannedEmails ADD CONSTRAINT PK_BannedEmails PRIMARY KEY NONCLUSTERED (Email)',
	N'Adding non clustered primary key to the bannedemails table',
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 25C53F5C5C-B11E-4037-84E2-6367F9E030A5',
	N'CREATE CLUSTERED INDEX IX_BannedEmails_DateAdded ON dbo.BannedEmails ( DateAdded DESC )',
	N'Adding clustered index on DateAdded to the bannedemails table',
	@curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'jac: 88C73459-2232-419F-9F41-380811B0514C',
N'exec dbu_createsiteoption 0, ''PersonalSpace'', ''IncludeRecentArticlesOfSubscribedToUsers'', ''0'' ,1,''Include recent articles written by users who have been subscribed to on personal space.''',
N'Creating SiteOption Personal Space - IncludeRecentArticlesOfSubscribedToUsers.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 27E3C77B-571D-4E8D-A79F-653353E8BBA8',
N'UPDATE dbo.ContentSignifAction SET ActionDesc = ''AddPositiveResponseToVote'' WHERE ActionDesc = ''AddResponseToVote'';',
N'Alter name of AddResponseToVote to AddPositiveResponseToVote.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: A7D6A774-3B17-45DB-BC6D-A04BE5F54498',
N'exec dbu_createsiteoption 0, ''Zeitgeist'', ''UseZeitgeist'', ''0'', 1, ''Does site use zeitgeist?''',
N'Add siteoption UseZeitgeist.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 29A309CC-DBCA-4893-A82F-5417ED52BC47',
N'DECLARE @SiteID INT;    
select @SiteID = SiteID from dbo.Sites where URLName = ''england'';    

exec dbu_createsiteoption @SiteID, ''Zeitgeist'', ''UseZeitgeist'', ''1'', 1, ''Does site use zeitgeist?''', 
N'Set SiteOption UseZeitgeist to true for england.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 4C6EE4D8-B74F-486C-AA2D-58CF1B932B19',
N'DECLARE @SiteID INT;    
select @SiteID = SiteID from dbo.Sites where URLName = ''actionnetwork'';    

exec dbu_createsiteoption @SiteID, ''Zeitgeist'', ''UseZeitgeist'', ''1'', 1, ''Does site use zeitgeist?''',
N'Set SiteOption UseZeitgeist to true for actionnetwork.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: FF15273F-CFE3-49F1-B523-2845DF15E1FF',
N'DECLARE @SiteID INT;    
select @SiteID = SiteID from dbo.Sites where URLName = ''collective'';    

exec dbu_createsiteoption @SiteID, ''Zeitgeist'', ''UseZeitgeist'', ''1'', 1, ''Does site use zeitgeist?''',
N'Set SiteOption UseZeitgeist to true for collective.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 4B3D208A-E4FD-426D-AEFC-33E362EBDD55',
N'DECLARE @SiteID INT; 
SELECT @SiteID = SiteID FROM dbo.Sites WHERE URLName = ''collective'';    

INSERT INTO ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (4, 1, @SiteID, 10);',
N'Insert collective zeitgeist AddPositiveResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 02029878-3FCD-48AA-8BF7-B52DD2C91A97',
N'DECLARE @SiteID INT; 
SELECT @SiteID = SiteID FROM dbo.Sites WHERE URLName = ''collective'';    

INSERT INTO ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (4, 2, @SiteID, 10);',
N'Insert collective zeitgeist AddPositiveResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 495A29BA-BE7F-4CC0-8C2F-6D3EB000B8E1',
N'DECLARE @SiteID INT; 
SELECT @SiteID = SiteID FROM dbo.Sites WHERE URLName = ''collective'';    

INSERT INTO ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (4, 5, @SiteID, 10);',
N'Insert collective zeitgeist AddPositiveResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: A0A61D44-D8B2-42B2-B17B-150D6EC00624',
N'DECLARE @SiteID INT; 
SELECT @SiteID = SiteID FROM dbo.Sites WHERE URLName = ''collective'';    

INSERT INTO ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (4, 6, @SiteID, 10);',
N'Insert collective zeitgeist AddPositiveResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 8E0A5600-E22F-4404-9676-9FD2444120A5',
N'INSERT INTO dbo.ContentSignifAction (ActionID, ActionDesc) SELECT ISNULL(max(ActionID), 0) + 1, ''AddNegativeResponseToVote'' FROM dbo.ContentSignifAction;',
N'Add new zeigeist action AddNegativeResponseToVote to DB.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 4B7B1F15-2FC0-460D-9E26-D796458857CE',
N'DECLARE @ActionID INT;    
SELECT @ActionID = ActionID FROM dbo.ContentSignifAction where ActionDesc = ''AddNegativeResponseToVote'';    

DECLARE @SiteID INT; 
select @SiteID = SiteID    
from dbo.Sites   
where URLName = ''collective'';

insert into ContentSignifIncrement VALUES (@ActionID, 1, @SiteID, -10)
insert into ContentSignifIncrement VALUES (@ActionID, 2, @SiteID, -10)
insert into ContentSignifIncrement VALUES (@ActionID, 5, @SiteID, -10)
insert into ContentSignifIncrement VALUES (@ActionID, 6, @SiteID, -10)',
N'INSERT AddNegativeResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: B3F06D9F-3E6E-49AF-98BF-28ED8E30C33A',
N'DECLARE @ActionID INT;    
SELECT @ActionID = ActionID FROM dbo.ContentSignifAction where ActionDesc = ''AddNegativeResponseToVote'';    

DECLARE @SiteID INT; 
select @SiteID = SiteID    
from dbo.Sites   
where URLName = ''actionnetwork'';

insert into ContentSignifIncrement values (@ActionID, 1, @SiteID, 5)
insert into ContentSignifIncrement values (@ActionID, 5, @SiteID, 5)',
N'INSERT AddNegativeResponseToVote values.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 78643B4D-7768-4E75-AEB8-1A77EC1A784E',
N'exec dbu_createsiteoption 0, ''Zeitgeist'', ''AddResponseToVote-IncrementAuthor'', ''0'', 1, ''AddResponseToVote can increment either the voter or the author of the item being voted on. Control which with this site option.''',
N'Add siteoption AddResponseToVote-IncrementAuthor to control whether voter or author of content being voted on get''s incremented in zeitgeist AddResponseToVote.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 873F1565-59AB-4025-A7CC-9C49AFDA72F7',
N'DECLARE @SiteID INT; 
select @SiteID = SiteID    
from dbo.Sites   
where URLName = ''collective'';

exec dbu_createsiteoption @SiteID, ''Zeitgeist'', ''AddResponseToVote-IncrementAuthor'', ''1'', 1, ''AddResponseToVote can increment either the voter or the author of the item being voted on. Control which with this site option.''',
N'Add Collective specific siteoption AddResponseToVote-IncrementAuthor.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: ACAC78F1-883E-4DF0-82A1-230087AC8520',
N'DECLARE @SiteID INT; 
SELECT @SiteID = SiteID FROM dbo.Sites WHERE URLName = ''collective'';    

INSERT INTO ContentSignifDecrement VALUES (0, 1, @SiteID, 1);
INSERT INTO ContentSignifDecrement VALUES (0, 2, @SiteID, 1);
INSERT INTO ContentSignifDecrement VALUES (0, 5, @SiteID, 1);
INSERT INTO ContentSignifDecrement VALUES (0, 6, @SiteID, 1);',
N'Add decrement values for collective.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jim: 24902EDA-B00F-43D7-ABF5-E3AC234D086C',
N'select g.*, m.UserID, m.SiteID into OldRecommendedGroupData
from groups g join groupmembers m on m.groupid = g.groupid
where g.System = 1

delete from groupmembers where groupid in (select groupid from groups where system = 1)
delete from groups where system = 1',
N'Remove multiple Recommended groups from the groups table to prevent the c# code blowing up', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jim:B3BB2E85-D172-45A9-B023-A1356F1522D9',
N'CREATE NONCLUSTERED INDEX [IX_UserSubscriptions_AuthorID] ON [dbo].[UserSubscriptions] 
(
	[AuthorId] ASC
)
INCLUDE ( [UserId]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]',
N'Index on UserSubscriptions indexed by AuthorID for the subscribedUsers list', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 242022DA-B20F-42D7-A2F5-E2A2224D0262',
N'CREATE NONCLUSTERED INDEX [IX_Preferences_PrefStatusDuration] ON [dbo].[Preferences] 
(
	[PrefStatusDuration] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]',
N'Creating the PrefStatusDuration Index on the preferences table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MarkH: 242022DA-B20F-42D7-9999-E2A2224D0269',
N'CREATE TABLE PreModGroupUsersBackUp (userid int, siteid int)
INSERT INTO PreModGroupUsersBackUp SELECT pu.userid, pu.siteid
FROM
(
	SELECT userid, siteid FROM dbo.GroupMembers gm
	INNER JOIN dbo.Groups g ON g.groupid = gm.groupid
	WHERE g.name = ''premoderated''
) AS pu

UPDATE dbo.Preferences SET PrefStatus = 1
FROM
(	
	SELECT p.userid, p.siteid FROM dbo.Preferences p
	INNER JOIN dbo.GroupMembers gm ON gm.userid = p.userid AND gm.siteid = p.siteid
	INNER JOIN dbo.Groups g ON g.groupid = gm.groupid
	WHERE g.name = ''premoderated''
) AS UU
WHERE dbo.Preferences.SiteID = UU.SiteID AND dbo.Preferences.UserID = UU.UserID

DELETE FROM dbo.GroupMembers WHERE dbo.GroupMembers.GroupID = (SELECT GroupID FROM dbo.Groups WHERE Name = ''premoderated'')

DELETE FROM dbo.Groups WHERE Name = ''premoderated''',
N'Update PrefStatus to 1 for all users in the Premod group. Remove the premoderated group from the groups table.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 5450525A-525F-42D7-9999-E2A2224D0269',
N'CREATE TABLE RestrictedGroupUsersBackUp (userid int, siteid int)
INSERT INTO RestrictedGroupUsersBackUp SELECT pu.userid, pu.siteid
FROM
(
	SELECT userid, siteid FROM dbo.GroupMembers gm
	INNER JOIN dbo.Groups g ON g.groupid = gm.groupid
	WHERE g.name = ''restricted''
) AS pu

UPDATE dbo.Preferences SET PrefStatus = 4
FROM
(	
	SELECT p.userid, p.siteid FROM dbo.Preferences p
	INNER JOIN dbo.GroupMembers gm ON gm.userid = p.userid AND gm.siteid = p.siteid
	INNER JOIN dbo.Groups g ON g.groupid = gm.groupid
	WHERE g.name = ''restricted''
) AS UU
WHERE dbo.Preferences.SiteID = UU.SiteID AND dbo.Preferences.UserID = UU.UserID

DELETE FROM dbo.GroupMembers WHERE dbo.GroupMembers.GroupID = (SELECT GroupID FROM dbo.Groups WHERE Name = ''restricted'')

DELETE FROM dbo.Groups WHERE Name = ''restricted''',
N'Update PrefStatus to 4 for all users in the restricted group. Remove the restricted group from the groups table.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 0481DEE5-1B0A-4524-B5D0-8B0EA7C7A9E8',
N'DELETE FROM dbo.ArticleLocation; ',
N'DELETE FROM dbo.ArticleLocation so new NOT NULL columns can be added easily.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: DAA657E0-54BA-4A4E-9D60-C837F9EB767A',
N'ALTER TABLE dbo.ArticleLocation ADD ZoomLevel INT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD ZoomLevel INT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 5D499F84-6F6B-49D1-B7B1-48B4A3BE6CDF',
N'ALTER TABLE dbo.ArticleLocation ADD UserID INT NOT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD UserID INT NOT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 7D40CCE3-B610-4805-92BF-BADB74D3C94A',
N'ALTER TABLE dbo.ArticleLocation ADD Approved BIT NOT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD Approved BIT NOT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: F53A6E0C-0E53-4E39-A2C0-E53BC1C95362',
N'ALTER TABLE dbo.ArticleLocation ADD CONSTRAINT DF_ArticleLocation_Approved DEFAULT 0 FOR Approved;',
N'ALTER TABLE dbo.ArticleLocation ADD CONSTRAINT DF_ArticleLocation_Approved DEFAULT 0 FOR Approved;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: A4F0C66D-C59F-4F8F-85AB-01FC8531D621',
N'ALTER TABLE dbo.ArticleLocation ADD DateCreated DATETIME NOT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD DateCreated DATETIME NOT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: C51BA264-9FF9-476E-94AF-30021FC730F5',
N'ALTER TABLE dbo.ArticleLocation ADD CONSTRAINT PK_ArticleLocation PRIMARY KEY NONCLUSTERED (ID);',
N'Add primary key to ArticleLocation.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql  N'jac: 943028B6-F36D-4CAC-87A5-C5F2E52F70F1',
N'ALTER TABLE dbo.ArticleLocation ADD CONSTRAINT FK_ArticleLocation_GuideEntries FOREIGN KEY (EntryID) REFERENCES GuideEntries (EntryID)',
N'Adding Foreign Key FK_ArticleLocation_GuideEntries',@curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql  N'jac: 968CC359-EDE9-4472-807B-497115385968',
N'ALTER TABLE dbo.ArticleLocation ADD CONSTRAINT FK_ArticleLocation_Users FOREIGN KEY (UserID) REFERENCES Users (UserID)',
N'Adding Foreign Key FK_UserSubscriptions_Users',@curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 8C88DA21-2D1F-4B51-95F7-16E8A706C08C',
N'ALTER TABLE dbo.ArticleLocation ADD Title VARCHAR(255) NOT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD Title VARCHAR(255) NOT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: F8975FBE-E249-4252-BDB6-3212D1B7807C',
N'ALTER TABLE dbo.ArticleLocation ADD Description VARCHAR(255) NOT NULL;',
N'ALTER TABLE dbo.ArticleLocation ADD Description VARCHAR(255) NOT NULL;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 6AA14EBF-E291-4585-9E95-62FC1584B3E3',
N'exec dbu_createsiteoption 0, ''Moderation'', ''DoNotSendEmail'', ''0'', 1, ''Do not send an email when failing a message on a comments site. Editorial failing of messages.''',
N'Add siteoption DoNotSendEmail to control if an email is sent when a message is failed for comments.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 4A3C70A2-D84B-472b-BC1A-6FB307B2EEA5',
N'exec dbu_createsiteoption 0, ''General'', ''AllowRobots'', ''0'', 1, ''Enable this option to allow search engine robots to discover and index Thread and Multi post pages on a site.''',
N'Add a site option to allow search engine robots to discover and index a site.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 535EED66-5DF4-4C15-AAC0-BEF97C24BC59',
N'CREATE NONCLUSTERED INDEX [IX_PageVotes_VoteID] ON [dbo].[PageVotes] ( [VoteID] ASC ) INCLUDE ( [ItemType])',
N'Creating IX_PageVotes_VoteID to speed up pollgetitemids', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 735CFC67-AAF2-454c-89AA-2140AF745C0C',
N'INSERT INTO dbo.ContentSignifAction (ActionID, ActionDesc) VALUES (10, ''SubscribeToUser'')',
N'Inserting SubscribeToUser action to ContentSignifAction table', @curerror OUTPUT
if (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 81052AA6-E361-414c-A782-05921CCE4183',
N'INSERT INTO dbo.ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (10, 1, 1, 10)',
N'Inserting SubscribeToUser signif increment data for h2g2', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Steve: 14AD5797-0311-4dc7-B762-68ACDA8642DC', 
N'GRANT SELECT ON UserStatuses TO ripleyrole',
N'Grant select on UserStatuses to ripleyrole', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Steve: F6FE0B20-3E03-42b8-B444-A5B391E36E2B', 
N'GRANT SELECT ON Mastheads TO ripleyrole',
N'Grant select on Mastheads to ripleyrole', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Steve: 1FF1AD36-9C31-42d6-B36D-A65CE95F68A2', 
N'GRANT SELECT ON ArticleLocation TO ripleyrole',
N'Grant select on ArticleLocation to ripleyrole', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Site Option PreModerateNewDiscussions
EXEC dbu_dosql N'MartinR: 1F2D1A85-79EC-4f9e-9FFB-39E3A96F3289',
N'exec dbu_createsiteoption 0, ''Moderation'', ''PreModerateNewDiscussions'', ''0'', 1, ''Set if first post of new discussion should be premoderated.''',
N'Creating SiteOption PreModerateNewDiscussions in Moderation.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 9F82FE9C-8D9C-45e2-8C44-1BD54AB2F973',
N'ALTER TABLE dbo.PostingQueue ADD ForcePreModeration tinyint',
N'Adding column ForcePreModeration to PostingsQueue', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

-- Adding new SiteID column to Threads table
EXEC dbu_dosql N'MarkN: 31149227-CE38-436C-BF75-BA2CE3F64860',
N'ALTER TABLE dbo.Threads ADD SiteID int NULL',
N'Adding SiteID to Threads', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 31149227-CE38-436C-BF75-BA2CE3F64861',
N'UPDATE dbo.Threads SET dbo.Threads.SiteID = f.SiteID
	FROM Forums f WHERE f.ForumID = dbo.Threads.ForumID',
N'Populating new SiteID column on Threads', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 31149227-CE38-436C-BF75-BA2CE3F64862',
N'ALTER INDEX PK_Threads ON dbo.Threads REBUILD',
N'Rebuilding clustered index on Threads after adding new SiteID column', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 31149227-CE38-436C-BF75-BA2CE3F64863',
N'CREATE NONCLUSTERED INDEX IX_Threads_SiteIDLastPosted
	ON dbo.Threads (SiteID, LastPosted DESC)
	INCLUDE (CanRead, VisibleTo)',
N'New index IX_Threads_SiteIDLastPosted', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Removing redundant Indexes
EXEC dbu_dosql N'MarkN: DCF1891A-0DA3-4A17-A122-3FC1B71D48C0',
N'DROP INDEX IX_Threads_LastPosted ON dbo.Threads',
N'Dropping IX_Threads_LastPosted.  Not needed now we have IX_Threads_SiteIDLastPosted', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DCF1891A-0DA3-4A17-A122-3FC1B71D48C1',
N'DROP INDEX IX_ThreadIDWithDate ON dbo.Threads',
N'Dropping IX_ThreadIDWithDate  Queries can use PK_Threads instead', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Clean Preferences table
EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D0',
N'SELECT p.* INTO dbo.PrefsClean FROM dbo.preferences p WITH(NOLOCK)
	LEFT JOIN dbo.mastheads m WITH(NOLOCK) ON m.userid=p.userid AND m.siteid=p.siteid
	WHERE m.userid IS NOT NULL OR p.userid = 0',
N'Creating PrefsClean table - i.e. only the prefs that should be in the table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D1',
N'CREATE UNIQUE CLUSTERED INDEX [IX_Preferences] ON [dbo].[PrefsClean] ([UserID] ASC, [SiteID] ASC)',
N'Creating IX_Preferences on PrefsClean', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D2',
N'CREATE NONCLUSTERED INDEX [IX_Preferences_DateJoined] ON [dbo].[PrefsClean] ([DateJoined] ASC)',
N'Creating IX_Preferences_DateJoined on PrefsClean', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D3',
N'CREATE NONCLUSTERED INDEX [IX_Preferences_PrefStatusDuration] ON [dbo].[PrefsClean] ([PrefStatusDuration] ASC)',
N'Creating IX_Preferences_PrefStatusDuration on PrefsClean', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D4',
N'EXEC sp_rename ''dbo.Preferences'', ''PreferencesOld'';
  EXEC sp_rename ''dbo.PrefsClean'', ''Preferences'';',
N'Renaming Preferences to PreferencesOld, and PrefsClean to Preferences', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D5',
N'DROP INDEX IX_Preferences_DateJoined ON dbo.PreferencesOld;
  DROP INDEX IX_Preferences_PrefStatusDuration ON dbo.PreferencesOld;',
N'Dropping redundant indexes on PreferencesOld', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D6',
N'GRANT SELECT ON dbo.Preferences TO ripleyrole',
N'Granting SELECT Permission on new Preferences table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: DEB65532-4943-4149-BE9B-DBD729A6B3D7',
N'GRANT INSERT ON dbo.Preferences TO ripleyrole
  GRANT UPDATE ON dbo.Preferences TO ripleyrole',
N'Granting INSERT and UPDATE Permission on new Preferences table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Create some missing clustered indexes
EXEC dbu_dosql N'MarkN: 78F85170-D343-45B5-99D4-61803AD87F90',
N'ALTER TABLE [dbo].[Sites] DROP CONSTRAINT [PK_Sites]
  ALTER TABLE [dbo].[Sites] ADD  CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED ([SiteID] ASC)
  ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [PK_Groups]
  ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED ([GroupID] ASC)',
N'Creating clustered indexes on Sites and Groups', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: DA324EAB-1DD9-456d-A44A-7E581BAEC360',
N'ALTER TABLE dbo.ModerationClass ADD SortOrder tinyint NOT NULL DEFAULT 0',
N'Adding column SortOrder to ModerationClass', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 4998C967-4751-4a61-9015-967DC125B925',
N'UPDATE ModerationClass
SET sortorder = rownums.sortorder-1
FROM
( SELECT ROW_NUMBER() OVER ( ORDER BY ModClassid ASC ) ''sortorder'', ModClassID
	FROM ModerationClass ) AS rownums
INNER JOIN ModerationClass m ON m.ModClassID = rownums.ModClassId',
N'Populating ModeationClass SortOrder - Ordering by ModClassID', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: E3ED4003-5262-474c-941F-8AC323D5EF37',
N'INSERT INTO dbo.ContentSignifAction (ActionID, ActionDesc) VALUES (11, ''BookmarkArticle'')',
N'Inserting BookmarkArticle action to ContentSignifAction table', @curerror OUTPUT
if (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: D9E2B0D5-D76E-454a-AAA0-C9D3FAA3D73C',
N'INSERT INTO dbo.ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (11, 1, 1, 10)',
N'Inserting BookmarkArticle signif increment data for h2g2 for updating the user score', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: B80FB371-120A-4712-B42A-6F50009D53C8',
N'INSERT INTO dbo.ContentSignifIncrement (ActionID, ItemID, SiteID, Value) VALUES (11, 2, 1, 10)',
N'Inserting BookmarkArticle signif increment data for h2g2 for updating the article score', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 429BA610-7118-4e95-80FA-D78CCEDCC702',
N'EXEC sp_rename ''dbo.Links.Hidden'',''Private'',''COLUMN''',
N'Renaming Links Hidden column', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: A4E6EE91-846F-4d17-BA95-2F15991AD601',
N'EXEC sp_rename ''dbo.Links.BackHidden'',''Hidden'',''COLUMN''',
N'Renaming Links BackHidden column to Hidden', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 163722F9-0D53-4913-B7E4-0F3483F9E0F4',
N'ALTER TABLE dbo.Links ADD DestinationSiteId INT NULL',
N'Adding Destination SiteId to links table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: A80AB37A-120F-47F2-F42A-6FF0009D53C8',
N'ALTER TABLE dbo.BannedEmails ADD
	SignInBanned bit NOT NULL CONSTRAINT DF_BannedEmails_SignInBanned DEFAULT 1,
	ComplaintBanned bit NOT NULL CONSTRAINT DF_BannedEmails_ComplaintBanned DEFAULT 1',
N'Adding SignInBanned and ComplaintBanned columns to BannedEmails table.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 178EC005-CBED-4B27-BE09-7FC0A4961EF0',
N'GRANT SELECT ON dbo.AcceptedRecommendations TO ripleyrole
GRANT UPDATE ON dbo.AcceptedRecommendations TO ripleyrole
GRANT SELECT ON dbo.Ancestors TO ripleyrole
GRANT SELECT ON dbo.Ancestors2 TO ripleyrole
GRANT SELECT ON dbo.ArticleDateRange TO ripleyrole
GRANT SELECT ON dbo.ArticleKeyPhrases TO ripleyrole
GRANT SELECT ON dbo.ArticleMediaAsset TO ripleyrole
GRANT SELECT ON dbo.ArticleMod TO ripleyrole
GRANT SELECT ON dbo.AssetKeyPhrases TO ripleyrole
GRANT SELECT ON dbo.AudioAsset TO ripleyrole
GRANT SELECT ON dbo.blobs TO ripleyrole
GRANT SELECT ON dbo.Clubs TO ripleyrole
GRANT SELECT ON dbo.ContentSignifArticle TO ripleyrole
GRANT SELECT ON dbo.Forums TO ripleyrole
GRANT SELECT ON dbo.GeneralMod TO ripleyrole
GRANT DELETE ON dbo.GroupMembers TO ripleyrole
GRANT INSERT ON dbo.GroupMembers TO ripleyrole
GRANT SELECT ON dbo.GroupMembers TO ripleyrole
GRANT INSERT ON dbo.GuideEntries TO ripleyrole
GRANT SELECT ON dbo.GuideEntries TO ripleyrole
GRANT UPDATE ON dbo.GuideEntries TO ripleyrole
GRANT SELECT ON dbo.Hierarchy TO ripleyrole
GRANT SELECT ON dbo.HierarchyArticleMembers TO ripleyrole
GRANT SELECT ON dbo.HierarchyClubMembers TO ripleyrole
GRANT SELECT ON dbo.HierarchyNodeAlias TO ripleyrole
GRANT SELECT ON dbo.ImageAsset TO ripleyrole
GRANT SELECT ON dbo.Journals TO ripleyrole
GRANT SELECT ON dbo.KeyPhrases TO ripleyrole
GRANT SELECT ON dbo.MediaAsset TO ripleyrole
GRANT SELECT ON dbo.MediaAssetLibrary TO ripleyrole
GRANT SELECT ON dbo.MediaAssetMod TO ripleyrole
GRANT DELETE ON dbo.ModerationClassMembers TO ripleyrole
GRANT INSERT ON dbo.ModerationClassMembers TO ripleyrole
GRANT SELECT ON dbo.ModerationClassMembers TO ripleyrole
GRANT DELETE ON dbo.Moderators TO ripleyrole
GRANT INSERT ON dbo.Moderators TO ripleyrole
GRANT SELECT ON dbo.Moderators TO ripleyrole
GRANT SELECT ON dbo.NameSpaces TO ripleyrole
GRANT SELECT ON dbo.NicknameMod TO ripleyrole
GRANT SELECT ON dbo.PageVotes TO ripleyrole
GRANT SELECT ON dbo.PhraseNameSpaces TO ripleyrole
GRANT INSERT ON dbo.Preferences TO ripleyrole
GRANT SELECT ON dbo.Preferences TO ripleyrole
GRANT UPDATE ON dbo.Preferences TO ripleyrole
GRANT SELECT ON dbo.ScoutRecommendations TO ripleyrole
GRANT SELECT ON dbo.SiteKeyPhrases TO ripleyrole
GRANT SELECT ON dbo.Sites TO ripleyrole
GRANT SELECT ON dbo.ThreadEntries TO ripleyrole
GRANT SELECT ON dbo.ThreadMod TO ripleyrole
GRANT SELECT ON dbo.Threads TO ripleyrole
GRANT SELECT ON dbo.Users TO ripleyrole
GRANT UPDATE ON dbo.Users TO ripleyrole
GRANT SELECT ON dbo.VArticleAssets TO ripleyrole
GRANT SELECT ON dbo.VArticleAudioAssets TO ripleyrole
GRANT SELECT ON dbo.VArticleImageAssets TO ripleyrole
GRANT SELECT ON dbo.VArticleKeyphraseCounts TO ripleyrole
GRANT SELECT ON dbo.VArticleVideoAssets TO ripleyrole
GRANT SELECT ON dbo.VGuideEntryForumPostCount TO ripleyrole
GRANT SELECT ON dbo.VGuideEntryText_collective TO ripleyrole
GRANT SELECT ON dbo.VGuideEntryText_memoryshare TO ripleyrole
GRANT SELECT ON dbo.VHosts TO ripleyrole
GRANT SELECT ON dbo.VideoAsset TO ripleyrole
GRANT SELECT ON dbo.Votes TO ripleyrole
GRANT SELECT ON dbo.VThreadKeyphraseCounts TO ripleyrole
GRANT SELECT ON dbo.VVisibleGuideEntries TO ripleyrole',
N'Granting SELECT permissions to ripleyrole, extracted from NewGuide', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 178EC005-CBED-4B27-BE09-7FC0A4961EF1',
N'
IF db_name()=''TheGuide''
BEGIN
	IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N''ripley'')
	DROP LOGIN [ripley]

	CREATE LOGIN [ripley] WITH PASSWORD=N''p4ck3t0fthr33'', DEFAULT_DATABASE=[theGuide], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N''ripley'')
DROP USER [ripley]

CREATE USER [ripley] FOR LOGIN [ripley] WITH DEFAULT_SCHEMA=[dbo]',
N'Creating or Recreating the ripley accounts', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Site Option IncludeBookmarkCount
EXEC dbu_dosql N'SteveF: CF027ED3-1B71-4c46-9313-A5EE9E3D4B92',
N'exec dbu_createsiteoption 0, ''GuideEntries'', ''IncludeBookmarkCount'', ''0'', 1, ''Set if the Guide Entry XML should include the Bookmark Count.''',
N'Creating SiteOption IncludeBookmarkCount in GuideEntries', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Site Option CheckUserNameSet
EXEC dbu_dosql N'MarkH: AF027AD3-1A71-4A46-9313-A5AE9E3A4B92',
N'exec dbu_createsiteoption 0, ''General'',''CheckUserNameSet'', ''0'', 1, ''Set if you want to check to see if the user has not set their username/nickname yet.''',
N'Creating SiteOption CheckUserNameSet in General', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: ACA4BAB6-2184-4C3A-8395-2A346584A781A',
N'CREATE NONCLUSTERED INDEX [IX_NickNameMod_UserID] ON [dbo].[NicknameMod] 
(
	[UserID] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]',
N'CREATE NONCLUSTERED INDEX IX_NickNameMod_UserID', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MarkN: 0EA4D5F8-3AFA-49A4-92FF-E542DAFB3360',
N'
IF OBJECT_ID(''[DF_Preferences2_PrefForumShowMaxPosts]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefForumShowMaxPosts]  DEFAULT (0) FOR [PrefForumShowMaxPosts]
IF OBJECT_ID(''[DF_Preferences2_PrefUserMode]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefUserMode]  DEFAULT (0) FOR [PrefUserMode]
IF OBJECT_ID(''[DF_Preferences2_PrefStatus]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefStatus]  DEFAULT (0) FOR [PrefStatus]
IF OBJECT_ID(''[DF_Preferences2_PrefSkin]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefSkin]  DEFAULT (''Alabaster'') FOR [PrefSkin]
IF OBJECT_ID(''[DF_Preferences2_PrefReceiveWeeklyMailshot]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefReceiveWeeklyMailshot]  DEFAULT (1) FOR [PrefReceiveWeeklyMailshot]
IF OBJECT_ID(''[DF_Preferences2_PrefReceiveDailyUpdates]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefReceiveDailyUpdates]  DEFAULT (0) FOR [PrefReceiveDailyUpdates]
IF OBJECT_ID(''[DF_Preferences2_PrefForumThreadStyle]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefForumThreadStyle]  DEFAULT (0) FOR [PrefForumThreadStyle]
IF OBJECT_ID(''[DF_Preferences2_PrefForumStyle]'') IS NULL
	ALTER TABLE [dbo].[Preferences] ADD  CONSTRAINT [DF_Preferences2_PrefForumStyle]  DEFAULT (0) FOR [PrefForumStyle]
',
N'Adding the default constraints to the Preferences table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: FF70501E-236C-41E3-9543-D671259AAC47',
N'CREATE TABLE ThreadModCube
(
	UserID	INT,
	SiteID	INT, 
	Status	INT, 
	Date	DATETIME, 
	[Count]	INT
);',
N'CREATE TABLE ThreadModCube', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 0AD98264-1FE0-4789-A16B-F9B3CAEE942D',
N'CREATE CLUSTERED INDEX IX_TheadModCube_Date_Covering ON ThreadModCube (Date, UserID, SiteID, Status, Count);',
N'CREATE CLUSTERED INDEX IX_TheadModCube_Date_Covering', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'jac: EE883F2A-ECDA-41F1-876D-C76FCA2FD897',
N'CREATE TABLE ArticleModCube
(
	UserID	INT, 
	SiteID	INT, 
	Status	INT, 
	Date	DATETIME, 
	[Count]	INT
);',
N'CREATE TABLE ArticleModCube', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: D58E8C9A-12F3-4966-97C8-3ADDFCEC5372',
N'CREATE CLUSTERED INDEX IX_ArticleModCube_Date_Covering ON ArticleModCube (Date, UserID, SiteID, Status, Count);',
N'CREATE CLUSTERED INDEX IX_ArticleModCube_Date_Covering', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 03BBFCCB-67A4-406A-84F3-AC6C5932A36B',
N'CREATE TABLE NicknameModCube
(
	UserID	INT, 
	SiteID	INT, 
	Status	INT, 
	Date	DATETIME, 
	[Count]	INT
);',
N'CREATE TABLE NicknameModCube', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 107955B5-C892-40D6-AEA2-A7CD91AF7A11',
N'CREATE CLUSTERED INDEX IX_NicknameModCube_Date_Covering ON NicknameModCube (Date, UserID, SiteID, Status, Count);',
N'CREATE CLUSTERED INDEX IX_NicknameModCube_Date_Covering', @curerror OUTPUT
IF (@curerror <> 0) RETURN



--Drop existing constraints
EXEC dbu_dosql N'SteveF: E9E7DB99-4BD9-4b9f-831B-A8FE7B3E77F5',
N'ALTER TABLE [dbo].[ArticleLocation] DROP CONSTRAINT [PK_ArticleLocation];
ALTER TABLE [dbo].[ArticleLocation] DROP CONSTRAINT [FK_ArticleLocation_GuideEntries];
ALTER TABLE [dbo].[ArticleLocation] DROP CONSTRAINT [FK_ArticleLocation_Users];
ALTER TABLE [dbo].[ArticleLocation] DROP CONSTRAINT [DF_ArticleLocation_Approved]',
N'Dropping redundant indexes on ArticleLocationOld', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--rename existing ArticleLocation table to ArticleLocationOld
EXEC dbu_dosql N'SteveF: DB18EEC9-2708-4d36-8ECA-C59E11BD8756',
N'EXEC sp_rename ''dbo.ArticleLocation'', ''dbo.ArticleLocationOld'';',
N'Renaming ArticleLocation to ArticleLocationOld', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Refactor Article Location table to seperate Location table with an link table to Articles
EXEC dbu_dosql N'SteveF: A9611140-67E3-4bcb-B9C6-05CD5C7B536A',
N'CREATE TABLE [dbo].[Location](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[SiteID] [int] NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[ZoomLevel] [int] NULL,
	[UserID] [int] NOT NULL,
	[Approved] [bit] NOT NULL CONSTRAINT [DF_Location_Approved]  DEFAULT ((0)),
	[DateCreated] [datetime] NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GRANT SELECT ON dbo.Location TO ripleyrole',
N'Creating new location table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 5FEE52FB-E1C1-4fe5-AE60-1DB9DEEA9E3A',
N'CREATE TABLE [dbo].[ArticleLocation](
	[EntryID] [int] NOT NULL,
 	[LocationID] [int] NOT NULL,
CONSTRAINT [PK_ArticleLocation] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC,
	[LocationID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ArticleLocation]  WITH CHECK ADD  CONSTRAINT [FK_ArticleLocation_GuideEntries] FOREIGN KEY([EntryID])
REFERENCES [dbo].[GuideEntries] ([EntryID])

ALTER TABLE [dbo].[ArticleLocation]  WITH CHECK ADD  CONSTRAINT [FK_ArticleLocation_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])

CREATE NONCLUSTERED INDEX [IX_ArticleLocation_LocationID] ON [dbo].[ArticleLocation] ([LocationID] ASC)
GRANT SELECT ON dbo.ArticleLocation TO ripleyrole',
N'Creating new article - location link table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--New Route related tables
EXEC dbu_dosql N'SteveF: 278FCACC-883D-4e1f-8509-1C6B015AF4FD',
N'CREATE TABLE [dbo].[Route](
	[RouteID] [int] IDENTITY(1,1) NOT NULL,
	[EntryID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Approved] [bit] NOT NULL CONSTRAINT [DF_Route_Approved]  DEFAULT ((0)),
	[DateCreated] [datetime] NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
CONSTRAINT [PK_Route] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Route]  WITH CHECK ADD  CONSTRAINT [FK_Route_GuideEntries] FOREIGN KEY([EntryID])
REFERENCES [dbo].[GuideEntries] ([EntryID])

ALTER TABLE [dbo].[Route]  WITH CHECK ADD  CONSTRAINT [FK_Route_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GRANT SELECT ON dbo.Route TO ripleyrole',
N'Creating new route table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 3E11CBB1-67FF-4f80-833F-E740387CD8C4',
N'CREATE TABLE [dbo].[RouteLocation](
	[RouteID] [int] NOT NULL,
 	[LocationID] [int] NOT NULL,
 	[Order] [int] NOT NULL,
CONSTRAINT [PK_RouteLocation] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC,
	[LocationID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RouteLocation]  WITH CHECK ADD  CONSTRAINT [FK_RouteLocation_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])

ALTER TABLE [dbo].[RouteLocation]  WITH CHECK ADD  CONSTRAINT [FK_RouteLocation_Route] FOREIGN KEY([RouteID])
REFERENCES [dbo].[Route] ([RouteID])

CREATE NONCLUSTERED INDEX [IX_RouteLocation_LocationID] ON [dbo].[RouteLocation] ([LocationID] ASC)
GRANT SELECT ON dbo.RouteLocation TO ripleyrole',
N'Creating new routelocation link table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Site Option CheckUserNameSet
EXEC dbu_dosql N'MarkH: A50275D3-1571-4546-9513-55AE5E3A5B95',
N'exec dbu_createsiteoption 0, ''Moderation'', ''SetNewUsersNickNames'', ''1'', 1, ''This option sets all new users nicknames to their login name. Turning this off will result in the users name being set to U#####. The nickname will not be placed in the moderation queue.''',
N'Creating SiteOption CheckUserNameSet in General', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 58ABE75A-24B2-492f-B569-E531F15B9114',
N'ALTER TABLE [dbo].[Route] ADD SiteID INT NOT NULL',
N'Adding column SiteID to Route', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'SteveF: 08EFCF71-6C66-41f4-8CBB-3AA627F4A297',
N'ALTER TABLE [dbo].[Route] ALTER COLUMN EntryID INT NULL;',
N'Change EntryID column to allow nulls', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 3DD12D8A-D281-4A36-BD1E-34A9D5A00C9C',
N'IF OBJECT_ID(''dbo.Nums'') IS NOT NULL
BEGIN
	IF OBJECT_ID(''dbo.udf_splitint'') IS NOT NULL
		DROP FUNCTION dbo.udf_splitint
	IF OBJECT_ID(''dbo.udf_splitvarchar'') IS NOT NULL
		DROP FUNCTION dbo.udf_splitvarchar
	IF OBJECT_ID(''dbo.udf_splitvarcharwithdelimiter'') IS NOT NULL
		DROP FUNCTION dbo.udf_splitvarcharwithdelimiter
	DROP TABLE dbo.Nums
END

SELECT 1 AS n INTO dbo.Nums;

CREATE UNIQUE CLUSTERED INDEX IX_Nums ON dbo.Nums (n)

DECLARE @n int
SET @n=1
WHILE @n < power(2,19)
BEGIN
	INSERT INTO dbo.Nums SELECT n+@n FROM dbo.Nums
	SET @n=@n*2
END',
N'Drop schema bound objects before recreating dbo.Nums with 524288 records.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: CD10E70C-C387-4268-8F36-3E7226FC85A3',
N'IF OBJECT_ID(''dbo.udf_splitint'') IS NOT NULL
BEGIN 
	DROP FUNCTION dbo.udf_splitint
END
IF OBJECT_ID(''dbo.udf_splitvarchar'') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udf_splitvarchar
END
IF OBJECT_ID(''dbo.udf_splitvarcharwithdelimiter'') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udf_splitvarcharwithdelimiter
END

EXEC(''CREATE FUNCTION dbo.udf_splitvarcharwithdelimiter(@arr AS VARCHAR(8000), @delimiter char)
RETURNS TABLE 
AS
RETURN
	SELECT pos=1,element=0
'')
EXEC(''CREATE FUNCTION dbo.udf_splitvarchar(@arr AS VARCHAR(8000))
RETURNS TABLE 
AS
RETURN
	SELECT pos=1,element=0
'')

EXEC(''CREATE FUNCTION dbo.udf_splitint(@arr AS VARCHAR(8000))
RETURNS TABLE 
AS
RETURN
	SELECT pos=1,element=0
'')
',
N'Dependency issues in functions project require function stubs to be created before recreation during the build of the functions project. TODO: You must explicitly rebuild the functions project.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'jac: 0D3210FD-7146-4F98-B307-338ACA515F58',
	N'exec dbu_createsiteoption 1, ''GuideEntries'', ''IncludeBookmarkCount'', ''1'', 1, ''Set if the Guide Entry XML should include the Bookmark Count.''',
	N'In SmallGuide set SiteOption IncludeBookmarkCount to 1 for h2g2', @curerror OUTPUT

	EXEC dbu_dosql N'jac: AFF4D6FF-3AE5-471B-890B-19EB1A42F1D8',
	N'DECLARE @Count	INT
	DECLARE @h2g2ID	INT

	SELECT @Count = 10 

	SET ROWCOUNT @Count

	DECLARE UserPageCursor CURSOR FOR
	SELECT ge.h2g2ID
	  FROM dbo.Users u
			INNER JOIN dbo.Mastheads m ON u.UserID = m.UserID
			INNER JOIN dbo.GuideEntries ge ON m.EntryID = ge.EntryID

	OPEN UserPageCursor

	FETCH NEXT FROM UserPageCursor
	INTO @h2g2ID

	WHILE (@@FETCH_STATUS = 0 AND @Count > 0)
	BEGIN
		INSERT INTO dbo.Links (SourceType, SourceID, DestinationType, DestinationID, LinkDescription, DateLinked, Explicit, Hidden, Type, Private, TeamID, Relationship, Title, SubmitterID, EditedBy, LastUpdated, DestinationSiteId)
		SELECT	''userpage'', @h2g2ID, ''article'', ge.h2g2ID, ''Autogenerated test data'', getdate(), 0, 0, '''', 0, null, null, null, null, null, null, null
		  from dbo.GuideEntries ge
		 where ge.SiteID = 1 
		 order by ge.h2g2ID DESC 

		FETCH NEXT FROM UserPageCursor
		INTO @h2g2ID

		SET @Count = @Count - 1

		SET ROWCOUNT @Count
	END

	CLOSE UserPageCursor
	DEALLOCATE UserPageCursor

	SET ROWCOUNT 0 ',
	N'Populating dbo.Links for ArticleSearch bookmark count testing.', @curerror OUTPUT
END

--New UITemplate, UIField and related link tables
EXEC dbu_dosql N'SteveF: 6346C4DA-1478-4837-ABC2-F44A1B59E3A7',
N'CREATE TABLE [dbo].[UITemplate](
	[UITemplateID] [int] IDENTITY(1,1) NOT NULL,
	[BuilderGUID] uniqueidentifier NOT NULL
CONSTRAINT [PK_UITemplate] PRIMARY KEY CLUSTERED 
(
	[UITemplateID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]',
N'Creating new UITemplate table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 9BEAC27A-E446-41ba-8F6A-41210BD66ADC',
N'CREATE TABLE [dbo].[UIField](
	[UIFieldID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Label] [varchar](255) NULL,
	[Type] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsKeyPhrase] [bit] NOT NULL CONSTRAINT [DF_UIField_IsKeyPhrase]  DEFAULT ((0)),
	[KeyPhraseNamespace] [varchar](255) NULL,
	[Required] [bit] NOT NULL CONSTRAINT [DF_UIField_Required]  DEFAULT ((0)),
	[DefaultValue] [varchar](255) NULL,
	[Escape] [bit] NOT NULL CONSTRAINT [DF_UIField_Escape]  DEFAULT ((0)),
	[RawInput] [bit] NOT NULL CONSTRAINT [DF_UIField_RawInput]  DEFAULT ((0)),
	[IncludeInGuideEntry] [bit] NOT NULL CONSTRAINT [DF_UIField_IncludeInGuideEntry]  DEFAULT ((0)),
	[ValidateEmpty] [bit] NOT NULL CONSTRAINT [DF_UIField_ValidateEmpty]  DEFAULT ((0)),
	[ValidateNotEqualTo] [bit] NOT NULL CONSTRAINT [DF_UIField_ValidateNotEqualTo]  DEFAULT ((0)),
	[ValidateParsesOK] [bit] NOT NULL CONSTRAINT [DF_UIField_ValidateParsesOK]  DEFAULT ((0)),
	[NotEqualToValue] [varchar](255) NULL,
	[ValidateCustom] [bit] NOT NULL CONSTRAINT [DF_UIField_ValidateCustom]  DEFAULT ((0))	
CONSTRAINT [PK_UIField] PRIMARY KEY CLUSTERED 
(
	[UIFieldID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]',
N'Creating new UIField table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 2E008C19-0287-40bf-9E65-A3DD4D39F3F2',
N'CREATE TABLE [dbo].[UITemplateField](
	[UITemplateID] [int] NOT NULL,
 	[UIFieldID] [int] NOT NULL
CONSTRAINT [PK_UITemplateField] PRIMARY KEY CLUSTERED 
(
	[UITemplateID] ASC,
	[UIFieldID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UITemplateField]  WITH CHECK ADD  CONSTRAINT [FK_UITemplateField_UIField] FOREIGN KEY([UIFieldID])
REFERENCES [dbo].[UIField] ([UIFieldID])

ALTER TABLE [dbo].[UITemplateField]  WITH CHECK ADD  CONSTRAINT [FK_UITemplateField_UITemplate] FOREIGN KEY([UITemplateID])
REFERENCES [dbo].[UITemplate] ([UITemplateID])',
N'Creating new UITemplateField link table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 7BE7872A-43B9-422c-BA0B-D5797A5D2D7D',
N'ALTER TABLE [dbo].[Route] DROP CONSTRAINT [FK_Route_GuideEntries]',
N'Remove CONSTRAINT to guideEntry from the Route table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Site Option CloseThreadOnHideFirstPost
EXEC dbu_dosql N'MartinR: E9FBA01E-6B0D-4253-8ABB-6F72EE2479B8',
N'exec dbu_createsiteoption 0, ''Moderation'', ''CloseThreadOnHideFirstPost'', ''0'', 1, ''If set this option will automatically close a thread on hiding or failing the first post. Reinstating the post will re-open the thread.''',
N'Creating SiteOption CloseThreadOnHideFirstPost in Moderation', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Update Default for SiteIsPrivate Site Option
EXEC dbu_dosql N'MartinR: 16D7DE25-2E4D-44b2-9384-AE74A964EADC',
N'UPDATE SiteOptions SET VALUE=0 WHERE Name=''SiteIsPrivate'' AND Section=''General'' AND SiteID = 0',
N'Updating Default Value for Site Option SiteIsPrivate', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

--Adds Step field to the UITemplate
EXEC dbu_dosql N'SteveF: 6E535F7D-2649-42b4-AF93-EE1AC7402112',
N'ALTER TABLE dbo.[UIField] ADD Step int NOT NULL DEFAULT 0',
N'Adding column Step to UIField', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- AutoMod Audit table
EXEC dbu_dosql N'MarkN: C27BF05A-14E7-4B9D-8804-545C042F89A0',
N'CREATE TABLE AutoModAudit (
	AuditID INT NOT NULL IDENTITY, 
	UserID INT NOT NULL, 
	SiteID SMALLINT NOT NULL, 
	AuditDate SMALLDATETIME NOT NULL CONSTRAINT DF_AuditDate DEFAULT (getdate()), 
	ReasonID TINYINT NOT NULL,
	TrustPoints SMALLINT NOT NULL, 
	ModStatus TINYINT NOT NULL)

ALTER TABLE AutoModAudit ADD CONSTRAINT PK_AutoModAudit PRIMARY KEY CLUSTERED (AuditDate, AuditID)
CREATE NONCLUSTERED INDEX IX_AutoModAudit_UserID ON AutoModAudit(UserID)
',
N'AutoMod Audit table', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

-- AutoMod Audit Reasons table
EXEC dbu_dosql N'MarkN: C27BF05A-14E7-4B9D-8804-545C042F89A3',
N'CREATE TABLE AutoModAuditReasons (
	ReasonID TINYINT NOT NULL, 
	Description varchar(255) NOT NULL) 

CREATE UNIQUE CLUSTERED INDEX IX_AutoModAuditReasons ON AutoModAuditReasons(ReasonID)

INSERT INTO AutoModAuditReasons VALUES (0, ''SeededUser'')
INSERT INTO AutoModAuditReasons VALUES (1, ''NewUser'')
INSERT INTO AutoModAuditReasons VALUES (2, ''Post'')
INSERT INTO AutoModAuditReasons VALUES (3, ''AddTrustPoint'')
INSERT INTO AutoModAuditReasons VALUES (4, ''ModStatusChange'')
INSERT INTO AutoModAuditReasons VALUES (5, ''SyncModStatusToPremod'')
INSERT INTO AutoModAuditReasons VALUES (6, ''SyncTrustPointsToPremod'')
INSERT INTO AutoModAuditReasons VALUES (7, ''SyncToPostmod'')
INSERT INTO AutoModAuditReasons VALUES (8, ''IncIntoPremod'')
INSERT INTO AutoModAuditReasons VALUES (9, ''ReachedMaxIntoPremodCount'')
INSERT INTO AutoModAuditReasons VALUES (10, ''PostFailure'')
',
N'AutoMod Audit Reasons table', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 9CF08B9F-8175-41AC-BEDA-801656F431CE',
N'GRANT SELECT ON dbo.PreModPostings TO ripleyrole;',
N'GRANT SELECT ON dbo.PreModPostings TO ripleyrole;', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

--Adds TemplateName field to UITemplate
EXEC dbu_dosql N'SteveF: 501B0CF1-A521-47af-9494-8785AA9A3226',
N'ALTER TABLE dbo.[UITemplate] ADD TemplateName [varchar](255) NOT NULL CONSTRAINT DF_UITemplate_TemplateName DEFAULT ''TemplateName''',
N'Adding column Name to dbo.UITemplate', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Adds Permissions field to UIField
EXEC dbu_dosql N'SteveF: 8C25CE58-5A22-4f6a-8E86-D169E7E330CD',
N'ALTER TABLE dbo.[UIField] ADD Permissions [varchar](255) NOT NULL CONSTRAINT DF_UIField_Permissions DEFAULT ''Standard''',
N'Adding column Permissions to dbo.[UIField]', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: DB32E809-D044-4956-B2C3-BC10C7DF0D3A',
N'INSERT INTO AutoModAuditReasons VALUES (11, ''SyncToPremod'')
INSERT INTO AutoModAuditReasons VALUES (12, ''SyncToBanned'')
',
N'More AutoMod reasons.', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 2495864E-A543-4E67-8875-2FA1BB5F739B',
N'CREATE TYPE UserModStatus FROM TINYINT;',
N'CREATE TYPE UserModStatus FROM TINYINT;', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 8DD23E49-6509-409F-9CF3-B05C93B8788E',
N'CREATE TYPE AutoModTrustZone FROM TINYINT;',
N'CREATE TYPE AutoModTrustZone FROM TINYINT;', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: D81735F3-86FC-4A24-ACBB-5812A461980F',
N'ALTER TABLE Preferences ADD TrustPointPosts TINYINT NOT NULL CONSTRAINT DF_TrustPointPosts DEFAULT 0 WITH VALUES; 
ALTER TABLE Preferences ADD TrustPoints SMALLINT NOT NULL CONSTRAINT DF_TrustPoints DEFAULT 0 WITH VALUES;  
ALTER TABLE Preferences ADD ModStatus UserModStatus NOT NULL CONSTRAINT DF_ModStatus DEFAULT 0 WITH VALUES; 
ALTER TABLE Preferences ADD IntoPreModCount TINYINT NOT NULL CONSTRAINT DF_IntoPreModCount DEFAULT 0 WITH VALUES; 

ALTER INDEX IX_Preferences ON Preferences REBUILD;',
N'Alter Preferences table to support AutoMod functionality.', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 4D78D9C1-3A57-42BD-9015-61A666611E15',
N'ALTER TABLE Sites ADD BannedThresholdValue SMALLINT NOT NULL CONSTRAINT DF_BannedThresholdValue DEFAULT -5 WITH VALUES; 
ALTER TABLE Sites ADD PremodThresholdValue SMALLINT NOT NULL CONSTRAINT DF_PremodThresholdValue DEFAULT -1 WITH VALUES; 
ALTER TABLE Sites ADD PostmodThresholdValue TINYINT NOT NULL CONSTRAINT DF_PostmodThresholdValue DEFAULT 0 WITH VALUES; ; 
ALTER TABLE Sites ADD ReactiveThresholdValue TINYINT NOT NULL CONSTRAINT DF_ReactiveThresholdValue DEFAULT 1 WITH VALUES; ; 
ALTER TABLE Sites ADD MaxTrustValue TINYINT NOT NULL CONSTRAINT DF_MaxTrustValue DEFAULT 5 WITH VALUES; ; 
ALTER TABLE Sites ADD NumPostsPerTrustPoint TINYINT NOT NULL CONSTRAINT DF_NumPostsPerTrustPoint DEFAULT 2 WITH VALUES; ; 
ALTER TABLE Sites ADD MaxIntoPreModCount TINYINT NOT NULL CONSTRAINT DF_MaxIntoPreModCount DEFAULT 3 WITH VALUES; ; 
ALTER TABLE Sites ADD SeedUserTrustUsingPreviousBehaviour TINYINT NOT NULL CONSTRAINT DF_SeedUserTrustUsingPreviousBehaviour DEFAULT 1 WITH VALUES; ; 
ALTER TABLE Sites ADD InitialTrustPoints TINYINT NOT NULL CONSTRAINT DF_InitialTrustPoints DEFAULT 0 WITH VALUES;',
N'Alter Sites table to support AutoMod functionality.', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: FDB779B4-8A52-44B2-9899-29BA2DED204E',
N'CREATE TABLE AutoModTrustZones
(
	ID INT IDENTITY, 
	Description varchar(255) NOT NULL
);

INSERT INTO AutoModTrustZones VALUES (''Banned''); 
INSERT INTO AutoModTrustZones VALUES (''Premod''); 
INSERT INTO AutoModTrustZones VALUES (''BetweenPremodAndPostmod''); 
INSERT INTO AutoModTrustZones VALUES (''BetweenPostmodAndReactive'');
INSERT INTO AutoModTrustZones VALUES (''Reactive'');

ALTER TABLE AutoModTrustZones ADD CONSTRAINT PK_AutoModTrustZones_ID PRIMARY KEY CLUSTERED (ID)
',
N'Support table AutoMod_TrustZones to provide descriptions of AutoMod zones.', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'jac: 13D370F1-4E26-4A47-BE39-EE15EC152F52',
N'CREATE TABLE UserModStatus
(
	StatusID INT NOT NULL, 
	Description varchar(255) NOT NULL
);

INSERT INTO UserModStatus VALUES (0, ''Standard (aka reactive)''); 
INSERT INTO UserModStatus VALUES (1, ''Premoderated''); 
INSERT INTO UserModStatus VALUES (2, ''PostModerated''); 
INSERT INTO UserModStatus VALUES (3, ''SendForReview'');
INSERT INTO UserModStatus VALUES (4, ''Restricted (aka banned)'');

ALTER TABLE UserModStatus ADD CONSTRAINT PK_UserModStatus_ID PRIMARY KEY CLUSTERED (StatusID)
',
N'Support table AutoMod_TrustZones to provide descriptions of AutoMod zones.', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

-- Rename ModerationBilling column
EXEC dbu_dosql N'MartinR: 00FBF708-B5FF-4d20-BDA7-A84548E7640B',
N'EXECUTE sp_rename N''dbo.ModerationBilling.ThreadTotal'', N''ThreadModTotal'', ''COLUMN''',
N'Renaming Moderation Billing ThreadTotal ThreadModTotal', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

-- Add column to ModerationBilling column for total posts
EXEC dbu_dosql N'MartinR: BA00E4D2-AF8E-4d9f-8054-D6E64FA726C4',
N'ALTER TABLE dbo.[ModerationBilling] ADD ThreadTotal INT',
N'Adding ThreadTotal Total Number of Posts for a site', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Rename ModerationBilling column
EXEC dbu_dosql N'MartinR: 7E0FF4C0-85B3-484b-A042-0CA99D4425C2',
N'EXECUTE sp_rename N''dbo.ModerationBilling.ArticleTotal'', N''ArticleModTotal'', ''COLUMN''',
N'Renaming Moderation Billing ArticleTotal ArticleModTotal', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

-- Rename ModerationBilling column
EXEC dbu_dosql N'MartinR: 619B757B-EBCE-4e28-9FE4-6DBA0BFEF33B',
N'EXECUTE sp_rename N''dbo.ModerationBilling.GeneralTotal'', N''GeneralModTotal'', ''COLUMN''',
N'Renaming Moderation Billing GeneralTotal GeneralModTotal', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'MarkH: 0B055566-EEC4-4FC3-9D38-85A8EE723999',
	N'INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=1, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=2, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=3, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=4, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=5, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=6, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=7, Refer = 0
	  INSERT INTO Profanities SELECT Profanitiy=''fuck'', ModClassID=8, Refer = 0',
	N'Adding Profanities to Small Guide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MarkN: 9003A420-8CE3-436B-AF89-69EC342E28A0',
N'ALTER TABLE [dbo].[Links] DROP CONSTRAINT [IX_Links_Unique]

ALTER TABLE [dbo].[Links] ADD CONSTRAINT [IX_Links_Unique] UNIQUE NONCLUSTERED 
(
	[SourceType] ASC,
	[DestinationType] ASC,
	[DestinationID] ASC,
	[SourceID] ASC
)
',
N'Redefining IX_Links_Unique based on cost benefits suggested by dm_db_missing_index_group_stats after performance testing', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: 7D14B664-2A3A-4666-BEFA-CF72343B9546',
N'DROP INDEX [IX_ThreadMod] ON [dbo].[ThreadMod] WITH ( ONLINE = OFF )
CREATE NONCLUSTERED INDEX [IX_ThreadMod] ON [dbo].[ThreadMod] 
(
	[PostID] ASC,
	[ModID] ASC
)
INCLUDE ( [LockedBy],
[Status],
[DateCompleted],
[SiteID]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]',
N'IX_ThreadMod:Removing LockedBy, Status, Date Completed from Keys and adding to included columns. Adding siteId to index - getmoderationmemberdetails optimisations',
@curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: 3F0ADEFD-CE20-42ba-AE49-5C7A9E68F9A5',
N'DROP INDEX [IX_ArticleMod_h2g2ID] ON [dbo].[ArticleMod] WITH ( ONLINE = OFF )
CREATE NONCLUSTERED INDEX [IX_ArticleMod_h2g2ID] ON [dbo].[ArticleMod] 
(
	[h2g2ID] ASC
)
INCLUDE ( [ModID],
[Status],
[SiteID]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]',
'IX_ArticleMod_h2g2: Adding Status and SiteId to Included columns - getmoderationmemberdetails optimisations',
@curerror OUTPUT
IF (@curerror <> 0 ) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	IF NOT EXISTS (select 1 FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID = 54)
	BEGIN
		INSERT INTO dbo.Preferences (UserID, SiteID) VALUES ( 1090501859, 54 )
	END
	IF NOT EXISTS (select 1 FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID = 72)
	BEGIN
		INSERT INTO dbo.Preferences (UserID, SiteID) VALUES ( 1090501859, 72 )
	END
END

--Set up Default values for site option CloseThreadOnHideFirstPost
EXEC dbu_dosql N'MartinR: FB1225DD-7264-450c-AB44-0FBBE568B143',
N'INSERT INTO SiteOptions( SiteId, Section, Name, Value, Type, Description )
SELECT s.SiteID, so2.Section, so2.Name, 1 ''Value'', so2.Type, so2.Description
FROM Sites s
INNER JOIN SiteOptions so ON so.siteid = s.siteid AND so.section = ''General'' AND so.Name=''IsMessageBoard'' AND so.value = ''1''
INNER JOIN SiteOptions so2 ON so2.Name = ''CloseThreadOnHideFirstPost'' AND so2.Section = ''Moderation'' AND so2.siteid = 0
LEFT JOIN SiteOptions so3 ON so3.Name = ''CloseThreadOnHideFirstPost'' AND so3.Section = ''Moderation'' AND so3.siteid = s.siteid
WHERE so3.siteid IS NULL',
N'Setting site option CloseThreadOnHideFirstPost option for messageboards',
@curerror OUTPUT

IF DB_NAME() = 'SmallGuide'
BEGIN
	IF NOT EXISTS (select 1 FROM dbo.AllowedURLs WHERE URL = 'www.bbc.co.uk' AND SiteID = 1)
	BEGIN
		INSERT INTO dbo.AllowedURLs (URL, SiteID) VALUES ( 'www.bbc.co.uk', 1 )
	END
	IF NOT EXISTS (select 1 FROM dbo.AllowedURLs WHERE URL = 'www.microsoft.co.uk' AND SiteID = 1)
	BEGIN
		INSERT INTO dbo.AllowedURLs (URL, SiteID) VALUES ( 'www.microsoft.co.uk', 1 )
	END
	IF NOT EXISTS (select 1 FROM dbo.AllowedURLs WHERE URL = 'www.bbc.co.uk' AND SiteID = 16)
	BEGIN
		INSERT INTO dbo.AllowedURLs (URL, SiteID) VALUES ( 'www.bbc.co.uk', 16 )
	END
	IF NOT EXISTS (select 1 FROM dbo.AllowedURLs WHERE URL = 'www.microsoft.co.uk' AND SiteID = 16)
	BEGIN
		INSERT INTO dbo.AllowedURLs (URL, SiteID) VALUES ( 'www.microsoft.co.uk', 16 )
	END
END

EXEC dbu_dosql N'jac: F2F5BC8C-CF28-4D8B-9D9D-641F57927986',
N'CREATE TABLE ThreadModReferralsCube
(
	UserID	INT,
	SiteID	INT, 
	Status	INT, 
	Date	DATETIME, 
	[Count]	INT
);',
N'CREATE TABLE ThreadModReferralsCube', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: F487FD92-CBC9-42F8-A68E-C0FA856BEF53',
N'CREATE CLUSTERED INDEX IX_ThreadModReferralsCube_Date_Covering ON ThreadModReferralsCube (Date, UserID, SiteID, Status, Count);',
N'CREATE CLUSTERED INDEX IX_ThreadModReferralsCube_Date_Covering', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: CC5784AD-3688-43D7-A54C-9EABC853B6C1',
N'CREATE TABLE ArticleModReferralsCube
(
	UserID	INT,
	SiteID	INT, 
	Status	INT, 
	Date	DATETIME, 
	[Count]	INT
);',
N'CREATE TABLE ArticleModReferralsCube', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 22FBE4E2-0023-4520-A1BA-9229F63F1499',
N'CREATE CLUSTERED INDEX IX_ArticleModReferralsCube_Date_Covering ON ArticleModReferralsCube (Date, UserID, SiteID, Status, Count);',
N'CREATE CLUSTERED INDEX IX_ArticleModReferralsCube_Date_Covering', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jim: C99C2308-9D03-4B79-99E6-69E3742C7725',
N'CREATE NONCLUSTERED INDEX [IX_Threads_MostRecentThreads] ON [dbo].[Threads] 
(
	[DateCreated] DESC
)
INCLUDE ( [ThreadID],
[ForumID],
[VisibleTo],
[CanRead])  ON [PRIMARY]',
N'Create index for MostRecentConversations query based on DateCreated', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 9F7E8DF6-5FE2-401C-A1AB-EAA21A4C9C2E',
N'GRANT UPDATE ON dbo.Sites TO ripleyrole;',
N'GRANT UPDATE ON dbo.Sites TO ripleyrole;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 3E3BA631-E5AE-4A8E-9E98-D8BEF39BD08D',
N'GRANT INSERT ON dbo.ArticleMod TO ripleyrole;',
N'GRANT INSERT ON dbo.ArticleMod TO ripleyrole;', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: AD750749-BFA7-472D-A80F-6AB155F63E6A',
N'ALTER TABLE SiteSkins ALTER COLUMN SiteID INT NOT NULL; ',
N'ALTER TABLE SiteSkins ALTER COLUMN SiteID INT NOT NULL; ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 271F95A7-7285-4B4D-8FBA-22550A25D82F',
N'ALTER TABLE SiteSkins ALTER COLUMN SkinName varchar(50) NOT NULL; ',
N'ALTER TABLE SiteSkins ALTER COLUMN SkinName varchar(50) NOT NULL; ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 3FC4C7F1-F6D7-4A59-9C17-5CC9070B8402',
N'ALTER TABLE SiteSkins ADD CONSTRAINT PK_SiteSkins PRIMARY KEY CLUSTERED (SiteID, SkinName); ',
N'ALTER TABLE SiteSkins ADD CONSTRAINT PK_SiteSkins PRIMARY KEY CLUSTERED (SiteID, SkinName); ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 5D2C4E11-1713-46b8-BB6C-2F15D76555B5',
N'exec dbu_createsiteoption 0, ''GuideEntries'', ''ArticleDailyLimit'', ''0'', 0, ''Limit the number of articles a user may create on a daily basis ( 0 - no limit )''',
N'Creating SiteOption ArticleDailyLimit', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 55980243-A3F8-4341-A226-626E1D619538',
N'CREATE NONCLUSTERED INDEX IX_ThreadModIPAddress_IPAddress ON dbo.ThreadModIPAddress
	(
	IPAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Added index on IPAddress to ThreadModIPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 293D1A93-3712-47F3-85A0-D99B9B7D593D',
N'
IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_PostToForum'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_PostToForum];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_CompleteClubAction'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_CompleteClubAction'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.service_message_types
				WHERE name = ''//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote'')
BEGIN
	CREATE MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote];
END',
N'Create zeitgeist service broker messages.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 9867CDB6-2FD4-4B9C-A667-BD74171F792F',
N'
IF NOT EXISTS (SELECT 1
				 FROM sys.service_contracts
				WHERE name = ''//bbc.co.uk/dna/ZeitgeistEventContract'')
BEGIN
	CREATE CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract] ([//bbc.co.uk/dna/Zeitgeist_PostToForum] SENT BY INITIATOR, 
																[//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry] SENT BY INITIATOR,
																[//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy] SENT BY INITIATOR,
																[//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy] SENT BY INITIATOR, 
																[//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote] SENT BY INITIATOR,
																[//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote] SENT BY INITIATOR,
																[//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy] SENT BY INITIATOR, 
																[//bbc.co.uk/dna/Zeitgeist_CompleteClubAction] SENT BY INITIATOR
																	);
END',
N'Create zeitgeist service broker contract.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 70ACB90B-6629-4C45-8032-6D578BD1F8BA',
N'
IF NOT EXISTS (SELECT *
				 FROM sys.service_queues
				WHERE name = ''//bbc.co.uk/dna/SendZeitgeistEventQueue'')
BEGIN
	IF OBJECT_ID(''processzeitgeisteventresponse'') IS NULL
	BEGIN
		EXECUTE sp_executesql N''CREATE PROCEDURE processzeitgeisteventresponse AS SELECT TOP 1 * FROM dbo.Nums;''
	END

	CREATE QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON, PROCEDURE_NAME = dbo.processzeitgeisteventresponse, MAX_QUEUE_READERS = 4, EXECUTE AS SELF);
END

IF NOT EXISTS (SELECT *
				 FROM sys.service_queues
				WHERE name = ''//bbc.co.uk/dna/ReceiveZeitgeistEventQueue'')
BEGIN
	IF OBJECT_ID(''processzeitgeistevent'') IS NULL
	BEGIN
		EXECUTE sp_executesql N''CREATE PROCEDURE processzeitgeistevent AS SELECT TOP 1 * FROM dbo.Nums;''
	END

	CREATE QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] WITH ACTIVATION (STATUS = ON, PROCEDURE_NAME = dbo.processzeitgeistevent, MAX_QUEUE_READERS = 4, EXECUTE AS SELF);
END',
N'Create zeitgeist service broker queues.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'jac: 7375529D-9151-4B8B-A25C-AA27E4D21F8A',
N'
IF NOT EXISTS (SELECT 1
				 FROM sys.services
				WHERE name = ''//bbc.co.uk/dna/SendZeitgeistEventService'')
BEGIN
	CREATE SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService] ON QUEUE [//bbc.co.uk/dna/SendZeitgeistEventQueue];
END

IF NOT EXISTS (SELECT 1
				 FROM sys.services
				WHERE name = ''//bbc.co.uk/dna/ReceiveZeitgeistEventService'')
BEGIN
	CREATE SERVICE [//bbc.co.uk/dna/ReceiveZeitgeistEventService] ON QUEUE [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue] ([//bbc.co.uk/dna/ZeitgeistEventContract]); 
END',
N'Create zeitgeist service broker services.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 82F4C032-1F56-487c-A50E-E76061E81148',
N'CREATE NONCLUSTERED INDEX [IX_ThreadEntriesIPAddress_IPAddress] ON [dbo].[ThreadEntriesIPAddress] 
(
	[IPAddress] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
',
N'Added index on IPAddress to ThreadEntriesIPAddress', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'mrh: 6D12282A-B142-47A6-ADF4-FFCF5552C6EC.', 
N'exec dbu_createsiteoption 0, ''SignIn'', ''UseIdentitySignIn'', ''0'', 1, ''Set this option to ON if you want to use Identity as the Sign In System. OFF will fallback to using the SSO system.''',
N'Creating SiteOption ArticleDailyLimit', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: E9332698-C939-4049-8910-D2D15023C672',
N'exec dbu_createsiteoption 0, ''Forum'', ''AscendingGuestbookOrder'', ''0'', 1, ''Does site want ascending guestbook post ordering''',
N'Add general siteoption AscendingGuestbookOrder.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 69E9575A-79FF-4464-8FC4-FBD1FEEDAB0E',
N'DECLARE @SiteID INT;    
select @SiteID = SiteID from dbo.Sites where URLName = ''606'';    
exec dbu_createsiteoption @SiteID, ''Forum'', ''AscendingGuestbookOrder'', ''1'', 1, ''Does site want ascending guestbook post ordering''', 
N'Set SiteOption AscendingGuestbookOrder to true for 606.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Add SkinSet to Sites table.
EXEC dbu_dosql N'MartinR: 1B007D25-7579-4e17-9E56-F24096D5E1CB',
	N'ALTER TABLE dbo.Sites ADD SkinSet varchar(50) NOT NULL CONSTRAINT DF_Sites_SkinSet DEFAULT ''vanilla''', 'Adding AcceptSubscriptions Column to Users Table', 
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'mrh: {1B598CA6-E535-47f3-B2B4-3FF09EF31E95}.', 
N'exec dbu_createsiteoption 0, ''General'', ''IsKidsSite'', ''0'', 1, ''Set this option to ON if this site is a Kids site. OFF represents an Adult site.''',
N'Creating SiteOption ArticleDailyLimit', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 7AA55CE1-B6BB-4652-84A2-269A1655475D',
	N'BEGIN TRANSACTION 

-- Update the default skin of all sites to default skin
UPDATE SiteSkins  
SET SkinName = ''default''
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.DefaultSkin = sk.SkinName

-- Update site skins with default skin for h2g2.
UPDATE SiteSkins  
SET SkinName = DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = ''h2g2'' AND sk.SkinName = ''default''

-- Update site skins with default skin for cbbc.
UPDATE SiteSkins  
SET SkinName = DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = ''cbbc'' AND sk.SkinName = ''default''

-- Update site skins with default skin for 1xtra.
UPDATE SiteSkins  
SET SkinName = s.DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = ''1xtra'' AND sk.SkinName = ''default''


-- Give all Sites a skin set of vanilla
-- UPDATE Sites SET SkinSet = ''vanilla''

-- Setup sites that have a skinset defined.
UPDATE Sites SET SkinSet = ''boards'' WHERE DefaultSkin = ''boards''
UPDATE Sites SET SkinSet = ''acs'' WHERE DefaultSkin=''acs''
UPDATE Sites SET SkinSet = ''h2g2'' where urlname = ''h2g2''
UPDATE Sites SET SkinSet = ''collective'' WHERE urlname = ''collective''
UPDATE Sites SET SkinSet = ''filmnetwork'' WHERE urlname = ''filmnetwork''
UPDATE Sites SET SkinSet = ''606'' WHERE urlname = ''606''
UPDATE Sites SET SkinSet = ''moderation'' WHERE urlname = ''moderation''
UPDATE Sites SET SkinSet = ''memoryshare'' WHERE urlname = ''memoryshare''
UPDATE Sites SET SkinSet = ''sciencefictionlife'' WHERE urlname = ''mysciencefictionlife''
UPDATE Sites SET SkinSet = ''boards'' WHERE urlname = ''1xtra''
UPDATE Sites SET SkinSet = ''comedysoup'' WHERE urlname = ''comedysoup''
UPDATE Sites SET SkinSet = ''england'' WHERE urlname = ''england''
UPDATE Sites SET SkinSet = ''onthefuture'' WHERE urlname = ''onthefuture''
UPDATE Sites SET SkinSet = ''britishfilm'' WHERE urlname = ''britishfilm''

-- Add XML Skin for sites that have an xml skin in their skinset.
INSERT INTO SiteSkins( SiteId, SkinName, Description, UseFrames)
SELECT s.SiteId, ''xml'', ''xml'', 0
FROM Sites s 
LEFT JOIN SiteSkins ss ON ss.siteid = s.siteid AND ss.skinname = ''xml''
WHERE s.SkinSet IN ( ''boards'', ''h2g2'', ''collective'', ''filmnetwork'', ''606'',''memoryshare'',''sciencefictionlife'')
AND ss.skinname is null

-- Set all sites default skin to default.
UPDATE Sites SET DefaultSkin = ''default''

-- Override for sites where default skin is not default.
UPDATE Sites SET DefaultSkin = ''1xtra'' WHERE urlname = ''1xtra''
UPDATE Sites SET DefaultSkin = ''cbbc'' WHERE urlname = ''cbbc''
UPDATE Sites SET DefaultSkin = ''brunel'' WHERE urlname = ''h2g2''

-- Update User Preferences ensuring user pref skins are valid
UPDATE Preferences
SET PrefSkin = s.DefaultSkin
FROM Preferences p
INNER JOIN sites s ON s.siteid = p.siteid
LEFT JOIN SiteSkins sk ON sk.skinname = p.prefskin AND sk.SiteId = s.SiteId
WHERE sk.SkinName IS NULL

-- Clear up vanilla skins added for blog sites.
-- It is not necessary to specify vanilla as an optional skin.
-- The vanilla skin is part of the fallback behaviour
DELETE ss
FROM SiteSkins ss
INNER JOIN Sites s ON s.siteid = ss.siteid
WHERE ss.skinname != s.defaultskin and (ss.skinname = ''vanilla'' or ss.skinname=''vanilla-json'')

COMMIT TRANSACTION', 'Vanilla Skin Restructure',
@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 09E2AFD3-EF61-47a5-9A2C-D02A1F1C553C', 
N'exec dbu_createsiteoption 0, ''Forum'', ''PostLimit'', ''0'', 0, ''Limit the number of posts per thread. Thread closed when limit reached. ( 0 - No limit )''',
N'Creating SiteOption PostCountLimit', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'mrh: {53DBAD59-6347-4d44-B2F3-8DC13B5750E0}.', 
	N'INSERT INTO Sites SELECT ''Identityblogs'',''Identity blogs'',''default'',0,0,''identityblogs'',''moderator@b.c'',''editor@b.c'',''feedback@b.c'',294,0,1,0,NULL,1,''Email Alert'',0,0,1,0,0,0,0,0,''Identityblogs'',-5,-1,0,1,5,2,3,1,0,''boards''
	INSERT INTO Sites SELECT ''Identity606'',''Identity 606'',''default'',0,0,''identity606'',''moderator@b.c'',''editor@b.c'',''feedback@b.c'',294,0,1,0,NULL,1,''Email Alert'',0,0,1,0,0,0,0,0,''Identity606'',-5,-1,0,1,5,2,3,1,0,''606''
	DECLARE @SiteID int
	SELECT @SiteID = SiteID from sites where urlname = ''identity606''
	INSERT INTO siteskins select @SiteID,''default'',''default'',0
	INSERT INTO siteskins select @SiteID,''xml'',''xml'',0
	INSERT INTO preferences select 0,0,0,0,0,0,''default'',0,@SiteID,1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,0,0
	INSERT INTO DefaultPermissions SELECT @SiteID,1,0,1,1,0,0,0,0,0,1,0,0,1,1,0,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,1,0
	EXEC setsiteoption @SiteID, ''SignIn'', ''UseIdentitySignIn'', ''1''
	SELECT @SiteID = SiteID from sites where urlname = ''identityblogs''
	INSERT INTO siteskins select @SiteID,''default'',''default'',0
	INSERT INTO siteskins select @SiteID,''xml'',''xml'',0
	INSERT INTO preferences select 0,0,0,0,0,0,''default'',0,@SiteID,1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,0,0,0,0
	INSERT INTO DefaultPermissions SELECT @SiteID,1,0,1,1,0,0,0,0,0,1,0,0,1,1,0,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,1,0
	EXEC setsiteoption @SiteID, ''SignIn'', ''UseIdentitySignIn'', ''1''',
	N'Creating new smallguide identityblogs and identity606 sites', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

IF OBJECT_ID('SignInUserIDMapping') IS NULL
BEGIN
	EXEC dbu_dosql N'mrh: {29214CA7-F795-4498-A09F-66FDC2054BB0}.', 
	N'
		CREATE TABLE [dbo].[SignInUserIDMapping](
			[DnaUserID] [int] NOT NULL,
			[SSOUserID] [int] NULL,
			[IdentityUserID] [int] NULL,
		 CONSTRAINT [PK_SignInUserIDMapping] PRIMARY KEY NONCLUSTERED 
		(
			[DnaUserID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]

		INSERT INTO dbo.SignInUserIDMapping SELECT u.UserID, u.UserID, NULL FROM dbo.Users u

		DECLARE @SeedValue int, @SQL nvarchar(2000)
		SELECT @SeedValue = MAX(DnaUserID) + 100000 FROM dbo.SignInUserIDMapping
		SELECT @SQL = ''
		CREATE TABLE dbo.Tmp_SignInUserIDMapping
			(
			DnaUserID int NOT NULL IDENTITY ('' + CAST(@SeedValue AS VARCHAR(50)) + '', 1),
			SSOUserID int NULL,
			IdentityUserID int NULL
			)  ON [PRIMARY]''
		EXEC(@SQL)

		SET IDENTITY_INSERT dbo.Tmp_SignInUserIDMapping ON

		IF EXISTS(SELECT * FROM dbo.SignInUserIDMapping)
			 EXEC(''INSERT INTO dbo.Tmp_SignInUserIDMapping (DnaUserID, SSOUserID, IdentityUserID)
				SELECT DnaUserID, SSOUserID, IdentityUserID FROM dbo.SignInUserIDMapping WITH (HOLDLOCK TABLOCKX)'')

		SET IDENTITY_INSERT dbo.Tmp_SignInUserIDMapping OFF

		DROP TABLE dbo.SignInUserIDMapping

		EXECUTE sp_rename N''dbo.Tmp_SignInUserIDMapping'', N''SignInUserIDMapping'', ''OBJECT'' 

		ALTER TABLE dbo.SignInUserIDMapping ADD CONSTRAINT
			PK_SignInUserIDMapping PRIMARY KEY NONCLUSTERED 
			(
			DnaUserID
			) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		CREATE UNIQUE CLUSTERED INDEX CIX_SignInUserIDMapping ON SignInUserIDMapping([SSOUserID])',
	N'Creating and updating SignInUserIDMapping table.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

/*
This section can never be run now that SignInUserIDMapping is being used.  SSOUserID can have multiple NULL entries
once in use, so it's not possible to create a unique clustered index on it (markn 24/2/09)

EXEC dbu_dosql N'Markn: C9D5826C-3B44-4032-A993-79664AB19600', 
N'
IF dbo.udf_indexcontainsfield(''SignInUserIDMapping'', ''PK_SignInUserIDMapping'', ''DnaUserID'') = 1
BEGIN
	ALTER TABLE SignInUserIDMapping DROP CONSTRAINT PK_SignInUserIDMapping
	ALTER TABLE SignInUserIDMapping ADD CONSTRAINT PK_SignInUserIDMapping PRIMARY KEY NONCLUSTERED(DnaUserID)
	CREATE UNIQUE CLUSTERED INDEX CIX_SignInUserIDMapping ON SignInUserIDMapping(SSOUserID)
END
',
N'Putting unique clustered index on SignInUserIDMapping(SSOUserID)', @curerror OUTPUT
IF (@curerror <> 0) RETURN
*/

EXEC dbu_dosql N'Markn: C9D5826C-3B44-4032-A993-79664AB19601', 
N'
IF [dbo].[udf_indexisunique](''SignInUserIDMapping'', ''CIX_SignInUserIDMapping'') = 0
BEGIN
	CREATE UNIQUE CLUSTERED INDEX CIX_SignInUserIDMapping ON SignInUserIDMapping(SSOUserID) WITH(DROP_EXISTING = ON)
end
',
N'Making index CIX_SignInUserIDMapping unique', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: C9D5826C-3B44-4032-A993-79664AB19602', 
N'
CREATE INDEX IX_SignInUserIDMappingIdentityUserID ON dbo.SignInUserIDMapping(IdentityUserID)
',
N'Creating index IX_SignInUserIDMappingIdentityUserID', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn : 0629A93A-198A-480A-9187-16CEF9B863B2',
N'DECLARE @SiteID INT;

set @siteid=null
select @SiteID = SiteID from dbo.Sites where URLName = ''mbcbbc'';
if @siteid is not null
	exec setsiteoption @SiteID, ''General'', ''IsKidsSite'', ''1''

set @siteid=null
select @SiteID = SiteID from dbo.Sites where URLName = ''mbnewsround'';
if @siteid is not null
	exec setsiteoption @SiteID, ''General'', ''IsKidsSite'', ''1''

set @siteid=null
select @SiteID = SiteID from dbo.Sites where URLName = ''mbgcsebitesize'';
if @siteid is not null
	exec setsiteoption @SiteID, ''General'', ''IsKidsSite'', ''1''

set @siteid=null
select @SiteID = SiteID from dbo.Sites where URLName = ''mbks3bitesize'';
if @siteid is not null
	exec setsiteoption @SiteID, ''General'', ''IsKidsSite'', ''1''',
N'Setting IsKidsSite to ON for mbcbbc, mbnewsround, mbgcsebitesize and mbks3bitesize', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SPF: EC962C58-C9C6-4fdb-855B-1042896C8460', 
N'GRANT SELECT ON ForumPostCountAdjust TO ripleyrole',
N'Grant select on ForumPostCountAdjust to ripleyrole', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MR: B2DA7766-DD05-4f0b-BC26-65B1C93C7EFF', 
N'DELETE FROM SiteSkins WHERE SkinName LIKE ''%vanilla%''',
N'Cleaning vanilla skin references from SiteSkins', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 7B099E07-128C-4881-9CD4-6EF675280CF8', 
N'UPDATE SiteSkins
	SET skinname = ''html''
	FROM SiteSkins sk 
	INNER JOIN Sites s ON s.siteid = sk.siteid
	WHERE s.skinset = ''vanilla'' and sk.skinname = s.defaultskin

	UPDATE Sites 
	SET defaultskin=''html'' where skinset = ''vanilla''' ,
N'Changing vanilla default skins to vanilla html', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 78C26BE9-1B66-49a0-B831-D3F72A3CB09A', 
N'UPDATE SiteOptions
    SET description=''Limit the number of posts per thread. Thread closed when limit reached. ( 0 - No limit. Only effects threads where parent forum is not associated with editors article. )''
    WHERE name=''postlimit'' AND section=''forum''',
N'Changing PostLimit Description', @curerror OUTPUT
IF (@curerror <> 0) RETURN
 
IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MH: {DD737608-9833-405a-B805-B4BAD0935ED1}', 
	N'INSERT INTO ThreadEntriesIPAddress SELECT entryid = 1, ipaddress = ''12.34.56.78'', bbcuid=''47BEB336-3409-00CF-CAD0-080020C4C7DD''',
	N'Adding ipaddress and bbcuid test data to ThreadEntriesIPAddress table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

	-- Removing test data as it's setup in the tests themselves and not hardwired.
	EXEC dbu_dosql N'MH: {DD737608-9833-405a-B805-B4BAD0935ED2}', 
	N'DELETE FROM ThreadEntriesIPAddress WHERE entryid = 1 AND ipaddress = ''12.34.56.78'' AND bbcuid=''47BEB336-3409-00CF-CAD0-080020C4C7DD''',
	N'Removing ipaddress and bbcuid test data from ThreadEntriesIPAddress table', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

END

EXEC dbu_dosql N'MH: {EE737608-9833-405a-B805-B4BAD0935ED2}', 
N'ALTER TABLE dbo.Sites ADD IdentityPolicy varchar(255) NULL',
N'Adding new IdentityPolicy colum to the sites table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MH: {00737608-9811-405a-B805-B4BAD0935ED2}', 
N'UPDATE dbo.Sites
	SET IdentityPolicy = ''http://identity/policies/dna/adult''
	WHERE SiteID IN
	(
		SELECT SiteID FROM dbo.SiteOptions
			WHERE Section = ''signin'' AND Value = ''1''
	)',
N'Setting default identity policies for sites using identity', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 6A2C2E2C-4097-4963-882E-FA68611341F5', 
N'IF dbo.udf_indexexists (''VVisibleArticleKeyPhrasesWithLastUpdated'', ''IX_VVisibleArticleKeyPhrasesWithLastUpdated'') = 1
BEGIN
	DROP INDEX [IX_VVisibleArticleKeyPhrasesWithLastUpdated] ON [dbo].[VVisibleArticleKeyPhrasesWithLastUpdated]
END', 
N'Drop index VVisibleArticleKeyPhrasesWithLastUpdated from VVisibleArticleKeyPhrasesWithLastUpdated if it exists.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 109DD733-1DDE-4793-A155-DFB252733AF0', 
N'
IF dbo.udf_indexisunique(''SignInUserIDMapping'',''CIX_SignInUserIDMapping'') = 1
BEGIN
	CREATE CLUSTERED INDEX CIX_SignInUserIDMapping ON [dbo].[SignInUserIDMapping]([SSOUserID] ASC)
	WITH (DROP_EXISTING = ON)
END
', 
N'Index CIX_SignInUserIDMapping cannot be unique because SSOUserID column can have multiple NULL entries', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- I changed the ID below, because this bit of DBUpgradeScript has changed.  When run against live, the original
-- scripts fails because CIX_SignInUserIDMappingSSOUserID already exists on live.  To fix it (yet again!)
-- it now only creates CIX_SignInUserIDMappingSSOUserID if it doesn't exist
-- (markn 24/2/09)
EXEC dbu_dosql N'Markn: 109DD733-1DDE-4793-A155-DFB252733AF2', 
N'
IF dbo.udf_indexexists(''SignInUserIDMapping'',''CIX_SignInUserIDMapping'') = 1
BEGIN
	DROP INDEX CIX_SignInUserIDMapping ON dbo.SignInUserIDMapping
END

IF dbo.udf_indexexists(''SignInUserIDMapping'',''IX_SignInUserIDMappingSSOUserID'') = 1
BEGIN
	DROP INDEX IX_SignInUserIDMappingSSOUserID ON dbo.SignInUserIDMapping
END

IF dbo.udf_indexexists(''SignInUserIDMapping'',''CIX_SignInUserIDMappingSSOUserID'') = 0
BEGIN
	CREATE CLUSTERED INDEX CIX_SignInUserIDMappingSSOUserID ON dbo.SignInUserIDMapping (SSOUserID ASC)
END
', 
N'Sorting out the indexes on SignInUserIDMapping again (second attempt)', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Mark H - {5DFB83AD-A5DA-4d8a-B5D5-F3F897E64E76}', 
N'
CREATE TABLE dbo.KeyValueData
	(
		DataKey uniqueidentifier NOT NULL,
		DataValue xml NOT NULL,
		DateCreated datetime NOT NULL
	)  ON [PRIMARY]
	TEXTIMAGE_ON [PRIMARY]
',
N'Creating new KeyValueData table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Mark H - {DFDF8C31-741C-47e8-9337-97DD6398B6C1}', 
N'
ALTER TABLE dbo.KeyValueData ADD CONSTRAINT
	DF_KeyValueData_DateCreated DEFAULT GetDate() FOR DateCreated
',
N'Setting default value for datecreated in the KeyValueData table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Mark H - {22A82DD7-C2ED-4c8d-BFC7-049EE9F37086}', 
N'
CREATE NONCLUSTERED INDEX IX_KeyValueData_DataKey ON dbo.KeyValueData
	(
		DataKey
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
',
N'Adding non clustered Index to the DataKey in the KeyValueData table', @curerror OUTPUT
IF (@curerror <> 0) RETURN




-- Inserting status' into AcceptedRecommendationStatus
--0	No Status	Should not get used
--1	Accepted	Scouts recommendation has been accepted and entry is waiting to be allocated to a Sub
--2	Allocated	Entry has been allocated to a Sub but not yet returned
--3	Returned	Entry has been returned by the Sub"	string
IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'map: {4A87BCFB-8400-4098-A8B2-94327A5BEEDF}.', 
	N'
	insert into [dbo].[AcceptedRecommendationStatus] ([Name],[Description]) values (''No Status'', ''Should not get used'')
	insert into [dbo].[AcceptedRecommendationStatus] ([Name],[Description]) values (''Accepted'', ''Scouts recommendation has been accepted and entry is waiting to be allocated to a Sub'')
	insert into [dbo].[AcceptedRecommendationStatus] ([Name],[Description]) values (''Allocated'', ''Entry has been allocated to a Sub but not yet returned'')
	insert into [dbo].[AcceptedRecommendationStatus] ([Name],[Description]) values (''Returned'', ''Entry has been returned by the Sub'')
	',
	N'Creating new smallguide AcceptedRecommendationStatus values', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

-- Inserting status' into ScoutRecommendationStatus
--0	No Status	Should not get used
--1	Recommended	Entry has been recommended by a Scout, but no staff decision has been made yet
--2	Rejected	Staff member rejected the recommendation
--3	Accepted	Staff member accepted this recommendation

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'map: {F6DDB408-94FB-4275-A541-143283688DD2}.', 
	N'
	insert into [dbo].[ScoutRecommendationStatus] ([Name],[Description]) values (''No Status'', ''Should not get used'')
	insert into [dbo].[ScoutRecommendationStatus] ([Name],[Description]) values (''Recommended'', ''Entry has been recommended by a Scout, but no staff decision has been made yet'')
	insert into [dbo].[ScoutRecommendationStatus] ([Name],[Description]) values (''Rejected'', ''Staff member rejected the recommendation'')
	insert into [dbo].[ScoutRecommendationStatus] ([Name],[Description]) values (''Accepted'', ''Staff member accepted this recommendation'')
	',
	N'Creating new smallguide AcceptedRecommendationStatus values', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'SPF: {96E1716A-7115-4c16-B646-A35ABB07F62F}', 
	N'
	DECLARE @EntryID INT;
	exec dbo.createguideentry @subject = ''A new batch of h2g2 entries to be subbed by ++**sub_name**++'', @bodytext = ''Dear ++**sub_name**++,    Here is your new batch of h2g2 Guide Entries for editing:    ++**batch_details**++    We hope you enjoy them! If you have any questions, please do not hesitate to contact us.    Best wishes,    The h2g2 Editorial Team    This e-mail, and any attachment, is confidential. If you have received  it in error, please delete it from your system, do not use or disclose  the information in any way, and notify me immediately. The contents of  this message may contain personal views which are not the views of the  BBC, unless specifically stated.'', @editor=6, @typeid=1, @status=10, @extrainfo=''TESTEMAILTEXT''
	SET @EntryID=null
	SELECT @EntryID = EntryID from dbo.GuideEntries where Subject = ''A new batch of h2g2 entries to be subbed by ++**sub_name**++'';
	insert into [dbo].[KeyArticles] ([ArticleName],[EntryID],[DateActive],[SiteID],[EditKey]) values (''SubAllocationsEmail'', @EntryID, getdate(), 1, ''5BA53567-B9B3-4F6A-A230-66538357A794'')
	',
	N'Creating new smallguide keyarticle for SuballocationsEmailText values', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

-- create banned user in small guide.
IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: {49A1986E-E101-4ef3-A8AD-BC1A8BA03F06}', 
	N'

	EXEC createnewuserfromssoid @ssouserid=1166868343, @username = ''DotNetUserBanned'', @email=''marcusparnwell.1@gmail.com'', @siteid=1, @firstnames=''DotNetUserBanned'', @lastname =''DotNetUserBanned''
	
	declare @userid int
	select @userid = DnaUserID
	from signinuseridmapping
	where SSOUserID = 1166868343
	
	update preferences
	set prefstatus=4
	where userid = @userid
	',
	N'Creating new test user which is banned', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MartinR: 6AF7C66F-80B0-4604-B4DE-149F1050C76E',
	N'CREATE TABLE dbo.ComplaintDuplicates
	(
		Hashvalue uniqueidentifier NOT NULL,
		ModId int NULL,
		DateCreated datetime NOT NULL
	)  ON [PRIMARY]',
	N'Creating ComplaintDuplicates table',   
	@curerror OUTPUT
	IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 33C69C01-CAA3-4a44-B6D9-3345E6802B1D',
	N'ALTER TABLE dbo.ComplaintDuplicates ADD CONSTRAINT
	PK_ComplaintDuplicates PRIMARY KEY CLUSTERED 
	(
	  Hashvalue
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]',
	N'Creating PK_ComplaintDuplicates',   
	@curerror OUTPUT
	IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {1374BAD7-CF9C-44c6-A5F6-43465D214DCA}',
	N'update sites
	set PreModeration = 0
	where shortname=''h2g2''',
	N'Ensure h2g2 IS NOT premoded',   
	@curerror OUTPUT
	IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: {018E28A7-B870-45a5-9195-0AF63526DEA1}',
N'exec dbu_createsiteoption 0, ''Forum'', ''ArticleAuthorCanCloseThreads'', ''0'', 1, ''Set if article author has the ability to close threads on articles forum''',
N'Creating SiteOption ArticleAuthorCanCloseThreads', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MRH: {3373B3D7-C393-3436-3536-333653234DCA}',
		N'
			EXEC dbo.addemailtobannedlist ''TotalBan@test.com'',1,1,1090558353
			EXEC dbo.addemailtobannedlist ''SignInBannedOnly@test.com'',1,0,1090558353
			EXEC dbo.addemailtobannedlist ''ComplainBannedOnly@Test.com'',0,1,1090558353
			EXEC dbo.addemailtobannedlist ''SuperUserAddedEmail@Test.com'',1,1,1090558354
		',
		N'Adding new email to the banned list',   
		@curerror OUTPUT
		IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MarcusP: {6615CF8B-AC13-4cdb-8416-8520B37AD2CB}',
N'
	CREATE TABLE dbo.ModerationStatus
	(
		id int NOT NULL,
		name varchar(50) NOT NULL
	)  ON [PRIMARY] 
	insert into dbo.ModerationStatus(id, name) values (1,''reactive'')
	insert into dbo.ModerationStatus(id, name) values (2,''postmod'')
	insert into dbo.ModerationStatus(id, name) values (3,''premod'')
	
	CREATE TABLE dbo.PostSytle
	(
		id int NOT NULL,
		name varchar(50) NOT NULL
	)  ON [PRIMARY]  
	insert into dbo.PostSytle (id,name) values (1,''guideml'')
	insert into dbo.PostSytle (id,name) values (2,''plain text'')
',
N'Creating dbo.ModerationStatus and dbo.PostSytle lookups', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 817893CE-3602-4eeb-B6A5-2E16BB51D1C9',
N'CREATE TABLE dbo.Smileys
	(
		name VARCHAR(256) NOT NULL,
		tag VARCHAR(256) NOT NULL,
		id INT IDENTITY(1,1) NOT NULL
	)  ON [PRIMARY]
',
N'Create table for storing smileys replaceing SmileyList.txt', @curerror OUTPUT
IF (@curerror <> 0) RETURN


IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: {3373B3D7-C393-3436-3536-333653234DEF}',
		N'
			EXEC dbo.addemailtobannedlist ''marcusparnwell.1@gmail.com'',1,1,1090558353
		',
		N'Adding new email ''marcusparnwell.1@gmail.com'' to the banned list',   
		@curerror OUTPUT
		IF (@curerror <> 0) RETURN
END


EXEC dbu_dosql N'MAP: {9DD5E274-D53B-492f-BACE-0335EBEA5CB6}',
N'exec dbu_createsiteoption 0, ''CommentForum'', ''MaxCommentCharacterLength'', ''0'' ,0,''Sets the maximum character length for a comment post - 0 denotes no limit''',
N'Creating SiteOption MaxCommentCharacterLength', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: {3798C3C5-FDAA-4ebf-9983-4122F26DCDC4}',
N'exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level0'', ''1'', 0, ''The number of solo edited entries to get Level 0 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level1'', ''25'', 0, ''The number of solo edited entries to get Level 1 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level2'', ''50'', 0, ''The number of solo edited entries to get Level 2 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level3'', ''75'', 0, ''The number of solo edited entries to get Level 3 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level4'', ''100'', 0, ''The number of solo edited entries to get Level 4 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level5'', ''150'', 0, ''The number of solo edited entries to get Level 5 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level6'', ''200'', 0, ''The number of solo edited entries to get Level 6 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level7'', ''250'', 0, ''The number of solo edited entries to get Level 7 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level8'', ''300'', 0, ''The number of solo edited entries to get Level 8 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level9'', ''350'', 0, ''The number of solo edited entries to get Level 9 ProlificScribe status.''
',
N'Solo Edited Entries Level ', @curerror OUTPUT
IF (@curerror <> 0) RETURN
 
EXEC dbu_dosql N'SteveF: {73021360-CBE0-479e-B84A-0157B576214C}', 
N'exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level0Group'', ''ProlificScribe0'', 2, ''The group denoting Level 0 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level1Group'', ''ProlificScribe1'', 2, ''The group denoting Level 1 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level2Group'', ''ProlificScribe2'', 2, ''The group denoting Level 2 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level3Group'', ''ProlificScribe3'', 2, ''The group denoting Level 3 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level4Group'', ''ProlificScribe4'', 2, ''The group denoting Level 4 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level5Group'', ''ProlificScribe5'', 2, ''The group denoting Level 5 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level6Group'', ''ProlificScribe6'', 2, ''The group denoting Level 6 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level7Group'', ''ProlificScribe7'', 2, ''The group denoting Level 7 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level8Group'', ''ProlificScribe8'', 2, ''The group denoting Level 8 ProlificScribe status.''
  exec dbu_createsiteoption 0, ''ProlificScribe'', ''Level9Group'', ''ProlificScribe9'', 2, ''The group denoting Level 9 ProlificScribe status.''
',
N'Solo Edited Entries LevelGroups ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: {F518A9CD-860E-4bad-A94B-328CE09C7CCB}', 
N'  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level0'', ''1'', 0, ''The number of solo edited entries to get Level 0 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level1'', ''25'', 0, ''The number of solo edited entries to get Level 1 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level2'', ''50'', 0, ''The number of solo edited entries to get Level 2 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level3'', ''75'', 0, ''The number of solo edited entries to get Level 3 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level4'', ''100'', 0, ''The number of solo edited entries to get Level 4 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level5'', ''150'', 0, ''The number of solo edited entries to get Level 5 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level6'', ''200'', 0, ''The number of solo edited entries to get Level 6 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level7'', ''250'', 0, ''The number of solo edited entries to get Level 7 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level8'', ''300'', 0, ''The number of solo edited entries to get Level 8 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level9'', ''350'', 0, ''The number of solo edited entries to get Level 9 ProlificScribe status.''
',
N'Solo Edited Entries Level Site 1', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: {181E8D4C-79E6-4df8-916D-CE33A6A7C558}', 
N'  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level0Group'', ''ProlificScribe0'', 2, ''The group denoting Level 0 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level1Group'', ''ProlificScribe1'', 2, ''The group denoting Level 1 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level2Group'', ''ProlificScribe2'', 2, ''The group denoting Level 2 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level3Group'', ''ProlificScribe3'', 2, ''The group denoting Level 3 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level4Group'', ''ProlificScribe4'', 2, ''The group denoting Level 4 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level5Group'', ''ProlificScribe5'', 2, ''The group denoting Level 5 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level6Group'', ''ProlificScribe6'', 2, ''The group denoting Level 6 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level7Group'', ''ProlificScribe7'', 2, ''The group denoting Level 7 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level8Group'', ''ProlificScribe8'', 2, ''The group denoting Level 8 ProlificScribe status.''
  exec dbu_createsiteoption 1, ''ProlificScribe'', ''Level9Group'', ''ProlificScribe9'', 2, ''The group denoting Level 9 ProlificScribe status.''
',
N'Solo Edited Entries LevelGroups Site 1 ', @curerror OUTPUT
-- Checking tables have been converted to support Unicode

EXEC dbu_dosql N'Markn: 4B9200F4-CADC-43FD-B608-BD19C80E3AD0',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''PreModPostings'',''Subject'')
IF @type IS NULL RAISERROR (''Failed to find type for column Subject on PreModPostings Subject'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''PreModPostings has not been converted to Unicode.  Run script Convert PreModPostings to Unicode.sql'',16,1)
END',
N'Checking that PreModPostings has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 4B9200F4-CADC-43FD-B608-BD19C80E3AD1',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''ThreadEditHistory'',''OldSubject'')
IF @type IS NULL RAISERROR (''Failed to find type for column OldSubject on ThreadEditHistory Subject'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''ThreadEditHistory has not been converted to Unicode.  Run script Convert ThreadEditHistory to Unicode.sql'',16,1)
END',
N'Checking that ThreadEditHistory has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 4B9200F4-CADC-43FD-B608-BD19C80E3AD2',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''ThreadEntries'',''Subject'')
IF @type IS NULL RAISERROR (''Failed to find type for column Subject on ThreadEntries Subject'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''ThreadEntries has not been converted to Unicode.  Run script Convert ThreadEntries to Unicode.sql'',16,1)
END',
N'Checking that ThreadEntries has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 4B9200F4-CADC-43FD-B608-BD19C80E3AD3',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''Forums'',''Title'')
IF @type IS NULL RAISERROR (''Failed to find type for column Title on Forums Subject'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''Forums has not been converted to Unicode.  Run script Convert Forums to Unicode.sql'',16,1)
END',
N'Checking that Forums has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 4B9200F4-CADC-43FD-B608-BD19C80E3AD4',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''Threads'',''FirstSubject'')
IF @type IS NULL RAISERROR (''Failed to find type for column FirstSubject on Threads Subject'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''Threads has not been converted to Unicode.  Run script Convert Threads to Unicode.sql'',16,1)
END',
N'Checking that Threads has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarcusP: {6615CF8B-AC13-4cdb-8416-8520B375D24D}',
N'
	CREATE TABLE dbo.PostHidden
	(
		id int NOT NULL,
		name varchar(100) NOT NULL
	)  ON [PRIMARY] 
	insert into dbo.PostHidden(id, name) values (1,''Removed - Failed moderation'')
	insert into dbo.PostHidden(id, name) values (2,''Hidden - Awaiting referral'')
	insert into dbo.PostHidden(id, name) values (3,''Hidden - Awaiting premoderation'')
	insert into dbo.PostHidden(id, name) values (4,''Not used'')
	insert into dbo.PostHidden(id, name) values (5,''Removed - Forum/Thread removed'')
	insert into dbo.PostHidden(id, name) values (6,''Removed - Editor complaint takedown'')
	insert into dbo.PostHidden(id, name) values (7,''Removed - user deleted'')
',
N'Creating dbo.PostHiddenLookup ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarcusP: {6615CF8B-AC13-4cdb-8416-8520B375D25F}',
N'
	CREATE TABLE [dbo].[ForumReview](
	[entryId] [int] NOT NULL,
	[forumId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[rating] [tinyint] NOT NULL,
 CONSTRAINT [PK_ForumReview] PRIMARY KEY CLUSTERED 
(
	[entryId] ASC,
	[forumId] ASC,
	[userId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

',
N'Creating ForumReview table for reviews for comments ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9DD5E274-D53B-492f-BACE-0335EBEA5CB7}',
N'exec dbu_createsiteoption 0, ''CommentForum'', ''MaxForumRatingScore'', ''5'' ,0,''Sets the maximum score for a rating''',
N'Creating SiteOption ''MaxForumRatingScore''', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Martinr: 0873AF5A-4D40-4a1d-A4EC-29EEA356A88E',
N'
	CREATE TABLE [dbo].[ThreadEntryEditorPicks](
	[entryId] [int] NOT NULL,
 CONSTRAINT [PK_EntryId] PRIMARY KEY CLUSTERED 
(
	[entryId] ASC
)
) ON [PRIMARY]

',
N'Creating EditorPicks table for comments ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Martinr: 453E59EA-6457-4cf8-A1B0-A06F28D836C2',
N'
CREATE TABLE [dbo].ExLinkMod
	(
	ModId int NOT NULL,
	Status int NOT NULL,
	SiteId int NOT NULL,
	LockedBy int NULL,
	DateLocked datetime NULL,
	DateQueued datetime NOT NULL,
	DateCompleted datetime NULL,
	URI varchar(255) NULL,
	CallBackURI varchar(255) NULL,
	Notes nvarchar(255) NULL,
	ComplaintText varchar(MAX) NULL,
	ReferredBy	int NULL,
	DateReferred datetime null,
	CONSTRAINT [PK_ModId] PRIMARY KEY CLUSTERED 
	(
		[ModId] ASC
	) 
	) ON [PRIMARY]
',
N'Creating External Links Moderation table', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN


EXEC dbu_dosql N'Martinr: B5DD5737-E9D8-4b78-9BAD-6CA6C186561D',
N'ALTER TABLE ExLinkMod DROP CONSTRAINT [PK_ModId]
ALTER TABLE ExlinkMod DROP COLUMN ModId
ALTER TABLE ExLinkMod ADD ModId INT Identity(1,1)
ALTER TABLE ExLinkMod ADD CONSTRAINT PK_ModId PRIMARY KEY CLUSTERED
(
	[ModId] ASC
)',
N'Creating Identity for ModId On External Links Moderation table', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: 1E59911D-E009-475c-8A4E-D100A2534D48',
N'sp_rename N''dbo.ThreadEntryEditorPicks.PK_EntryId'', N''PK_ThreadEntryEditorPicks_EntryId'', N''INDEX''',
N'Renaming Primary Key for ThreadEntryEditorPicks', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: DED5467A-61BA-4464-978F-6C3A5846971A',
N'sp_rename N''dbo.ExLinkMod.PK_ModId'', N''PK_ExLinkMod'', N''INDEX''',
N'Renaming Primary Key for ExLinkMod', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN


EXEC dbu_dosql N'DavidW: 3BBC7526-1D1B-4F8A-9522-B4316BBCE36E',
N'
IF object_id(''SNeSApplicationMetadata'') IS NULL
BEGIN
CREATE TABLE [dbo].[SNeSApplicationMetadata](
	[SiteID] [int] NOT NULL,
	[ApplicationID] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApplicationName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_SNeSApplicationMetadata] PRIMARY KEY CLUSTERED 
(
	[SiteID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SNeSActivityQueue](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventType] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemType] [int] NOT NULL,
	[ItemID2] [int] NOT NULL,
	[ItemType2] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventUserID] [int] NOT NULL
) ON [PRIMARY]

CREATE CLUSTERED INDEX [CIX_SNeSActivityQueue_EventID] ON [dbo].[SNeSActivityQueue] 
(
	[EventID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_SNeSActivityQueue_EventUserID] ON [dbo].[SNeSActivityQueue] 
(
	[EventUserID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
END
',
N'Creating tables and indexes SNeS Event handling and processing', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'1C74E38D-B5AC-468b-B567-656034F26532',
N'CREATE TABLE [dbo].ExModEventQueue
	(
	ModId int NOT NULL
	)  ON [PRIMARY]',
N'Creating External Moderation Event Queue', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 1EE4BFE3-D1A0-472d-A9B8-2140A84029CD',
N'ALTER TABLE dbo.ExModEventQueue ADD CONSTRAINT
	PK_ExModEventQueue PRIMARY KEY CLUSTERED 
	(
	ModId
	) ON [PRIMARY]',
N'Creating Primary Key on ExModEventQueue', @curerror OUTPUT
IF (@curerror <> 0) RETURN

--Add LIFOQueue to ModerationClass Table.
EXEC dbu_dosql N'SteveF: 6709865E-CE65-4613-AF66-6C626335E019',
	N'ALTER TABLE dbo.ModerationClass ADD LIFOQueue bit NOT NULL CONSTRAINT DF_ModerationClass_LIFOQueue DEFAULT 0', 'Adding LIFOQueue Column to ModerationClass Table', 
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: CDE7A5D6-8D4C-4586-ACB8-5879552C53D0',
  N'if dbo.udf_indexexists(''ThreadEntries'',''IX_ThreadEntries_ForumID'') = 1
	begin
		drop INDEX [IX_ThreadEntries_ForumID] ON [dbo].[ThreadEntries] 
	end

	CREATE NONCLUSTERED INDEX [IX_ThreadEntries_ForumID] ON [dbo].[ThreadEntries] 
	(
		[ForumID] ASC
	)
	INCLUDE ( [PostIndex],[Hidden],[Parent],[ThreadID],[UserID], LastUpdated, DatePosted)', 
	'Recreating IX_ThreadEntries_ForumID so it includes LastUpdated and DatePosted', 
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MartinR: 25A8A18E-97D6-40a0-B73E-37BE38A497D8',
	N'ALTER TABLE dbo.ModerationClassMembers ADD GroupID int NULL',
	N'Adding GroupId to Moderation Class Members',
	@curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'MartinR: 9265CB20-5364-44e2-A42E-33E3FDFA61D6',
	N'UPDATE ModerationClassMembers SET GroupID = ( SELECT GroupID FROM Groups WHERE name = ''moderator'' )',
	N'Setting up existing moderation class members to moderator group',
	@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: CCD09C2C-8BD4-47f1-820A-40DD2111015A', 
N'ALTER TABLE [dbo].[ForumReview] DROP CONSTRAINT [PK_ForumReview]; 

ALTER TABLE [dbo].[ForumReview] ADD CONSTRAINT [PK_ForumReview] PRIMARY KEY CLUSTERED 
(
	[ForumID] ASC, 
	[UserID] 
)',
N'Change ForumReview Primary Key.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: F1C72154-9A62-4b25-9681-22224B94C62C', 
N'CREATE NONCLUSTERED INDEX [IX_ForumReview_EntryID] ON [dbo].[ForumReview] 
(
	[EntryID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]',
N'Change ForumReview Add EntryID Non Clus Index.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 83236F21-CE1F-4EE6-BC33-803C98AC2A00', 
N'
if dbo.udf_indexexists(''CommentForums'',''IX_CommentForums_SiteId'') = 0
BEGIN
	CREATE NONCLUSTERED INDEX IX_CommentForums_SiteId ON dbo.CommentForums ( SiteID ASC)
END
',
N'Index on SiteID for CommentForums to make commentforumsreadbysitename go faster', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 0925F182-7015-4498-925C-72ABACFB1DB0', 
N'
if dbo.udf_indexexists(''ModReason'',''IX_ModeReason_EmailName'') = 0
BEGIN
	-- Remove duplicates
	;with s as
	(
		select *,row_number() over(Partition by EmailName order by reasonid,EmailName) n 
		from dbo.ModReason
	)
	delete from s
	where n > 1

	CREATE UNIQUE NONCLUSTERED INDEX [IX_ModeReason_EmailName] ON [dbo].[ModReason] ([EmailName] ASC)
END
',
N'Added unique index IX_ModeReason_EmailName to ModReason to stop it from acquiring duplicates', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 0925F182-7015-4498-925C-72ABACFB1DB1', 
N'
if dbo.udf_indexexists(''ModReason'',''IX_ModReason_DisplayName'') = 0
BEGIN
	-- Remove duplicates
	;with s as
	(
		select *,row_number() over(Partition by DisplayName order by reasonid,DisplayName) n 
		from dbo.ModReason
	)
	delete from s
	where n > 1

	CREATE UNIQUE NONCLUSTERED INDEX [IX_ModReason_DisplayName] ON [dbo].[ModReason] ([DisplayName] ASC)
END
',
N'Added unique index IX_ModReason_DisplayName to ModReason to stop it from acquiring duplicates', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: D2D18971-B4EF-4000-990C-29F25AD5084D',
N'exec dbu_createsiteoption 0, ''Moderation'', ''NicknameModerationStatus'', ''0'' ,0,''0 - Nicknames Unmoderated, 1 - Nicknames PostModerated, Nicknames, 2 - Nicknames Premoderated''',
N'Creating SiteOption ''NicknameModerationStatus''', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MR: 23C2BF0B-2AD9-4103-9928-1CA5ADF4E087',
N'DELETE FROM SiteOptions WHERE Section=''Moderation'' AND Name=''PremoderateNicknameChanges''',
N'Deleting SiteOption ''PreModerateNicknameChanges''', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Add a referred profanity to Small Guide
IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'MartinR: 0401DC6C-7197-4b65-801A-8ECCB4713A06',
	N'INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,1)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,2)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,3)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,4)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,5)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,6)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,7)
	INSERT INTO Profanities ( Profanity, Refer, ModClassID) VALUES
	(''arse'',1,8)',
	N'Adding referred profanity into Small Guide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MR: EB692917-6DE5-4dc6-9ED2-16B38C758E2B',
N'CREATE TABLE dbo.ExLinkModHistory
	(
	ModId int NOT NULL,
	ReasonID int NOT NULL,
	Notes nvarchar(50) NULL,
	TimeStamp smalldatetime NOT NULL
	)  ON [PRIMARY]',
	N'Creating ExLinkModHistory Table', @curerror OUTPUT
	IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MR: 071480D4-FD27-45ff-A4A4-4EAB02D3BA7E',
N'UPDATE SiteOptions SET Description = ''0 - Nicknames Unmoderated, 1 - Nicknames PostModerated, 2 - Nicknames Premoderated'' WHERE Name = ''NicknameModerationStatus'' AND Section=''Moderation''',
N'Updating Nickname ModerationStatus Description', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'97C1D527-DF03-4e42-94D0-38D4DB4104C6',
N'ALTER TABLE dbo.ExModEventQueue ADD
	RetryCount int NULL, 
	LastRetry smalldatetime NULL',
	N'Altering ExModEventQueue table - adding colimns to support retries', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'MH-97C1D527-DF03-4e42-94D0-38D1111104C8',
N'ALTER TABLE dbo.Users ADD
	LastUpdatedDate datetime NULL',
	N'Altering User table - adding last updated date column', @curerror OUTPUT
IF ( @curerror <> 0 ) RETURN

EXEC dbu_dosql N'MR: 23C2BF0B-2AD9-4103-9928-1CA5ADF4E087',
N'DELETE FROM SiteOptions WHERE Section=''Moderation'' AND Name=''PremoderateNicknameChanges''',
N'Deleting SiteOption ''PreModerateNicknameChanges''', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Add a smileys to Small Guide
IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'MarcusP: 397ED2DE-1EA2-4d99-8F54-D494E81735FB',
	N'INSERT INTO Smileys ( name, tag) VALUES
	(''kiss'',''<kiss>'')
	INSERT INTO Smileys ( name, tag) VALUES
	(''ale'',''<ale>'')
	INSERT INTO Smileys ( name, tag) VALUES
	(''spork'',''--OE'')
	',
	N'Adding Smileys into Small Guide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'SPF: {F15C9295-241E-4EAF-A18A-26DF70BD96E0}',
N'exec dbu_createsiteoption 0, ''CommentForum'', ''MinCommentCharacterLength'', ''0'' ,0,''Sets the minimum character length for a comment post - 0 denotes no limit''',
N'Creating SiteOption MinCommentCharacterLength', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: A8F98011-B3A3-48CB-B1F7-FC76A5ED0660',
N'
IF dbo.udf_viewexists(''VGuideEntryText_collective'') = 1
BEGIN
	DROP VIEW VGuideEntryText_collective
END
',
N'Dropping view VGuideEntryText_collective as that site is no longer', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {F1E83579-F0FD-46ef-B66C-FB30AEFD2D51}',
N'
exec dbu_createsiteoption 0, ''Forum'', ''EnableStickyThreads'', ''0'' ,1,''Turns on and off sticky thread functionality''',
N'Creating SiteOption EnableStickyThreads', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {F1E83579-F0FD-46ef-B66C-FB30AEFD2D4Z}',
N'

CREATE TABLE [dbo].[StickyThreads](
	[forumid] [int] NOT NULL,
	[threadid] [int] NOT NULL,
	[userid] [int] NOT NULL,
	[sortby] [int] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_stickythreads] PRIMARY KEY NONCLUSTERED 
(
	[forumid] ASC,
	[threadid] ASC
)
) 

CREATE CLUSTERED INDEX [IX_StickyThreads] ON [dbo].[StickyThreads]([forumid] ASC, [sortby] ASC)
',
N'Creating sticky thread table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {F1E83579-F0FD-46ef-B66C-FB30AEFD2D4F}',
N'
CREATE TABLE [dbo].[AuditStickyThreadsTypeLookup](
	[id] int NOT NULL,
	[name] varchar(50) NOT NULL
) 

insert into AuditStickyThreadsTypeLookup (id, name) values (1, ''delete'')
insert into AuditStickyThreadsTypeLookup (id, name) values (2, ''insert'')

CREATE TABLE [dbo].[AuditStickyThreads](
	[forumid] [int] NOT NULL,
	[threadid] [int] NOT NULL,
	[userid] [int] NOT NULL,
	[type] [int] DEFAULT (0)
) 

',
N'Creating sticky thread audit table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: 6D1F287A-B14B-47A6-ADC4-DFCF5552C6EC', 
	N'INSERT INTO dbo.SiteOptions SELECT Section = ''Forum'', SiteID = 1, Name = ''EnableStickyThreads'', Value = ''1'', Type = 1, Description = ''Enabled sticky threads''', 
	N'Turning on sticky threads for h2g2.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MAP: {A204C925-199C-4279-A920-5E9C7D70C64E}', 
N'
ALTER TABLE dbo.ModerationClass ADD CONSTRAINT
PK_ModerationClass_1 PRIMARY KEY CLUSTERED 
(
ModClassID
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

', 
N'Adding primary key to moderationclass table so it can be foreign keyed.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {A204C925-199C-4279-A920-5E9C7D70C64E}_1', 
N'
CREATE TABLE [dbo].[TermsActionLookup](
	[id] [tinyint] NOT NULL,
	[action] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_TermsActionLookup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into [dbo].[TermsActionLookup](id, action) values (0, ''No action'')
insert into [dbo].[TermsActionLookup](id, action) values (1, ''Refer'')
insert into [dbo].[TermsActionLookup](id, action) values (2, ''Reedit'')

CREATE TABLE [dbo].[TermsLookup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[term] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_TermsLookup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[TermsByModClass](
	[termid] [int] NOT NULL,
	[modclassid] [int] NOT NULL,
	[actionid] [tinyint] NOT NULL CONSTRAINT [DF_TermsByModClass_action]  DEFAULT ((0))
) ON [PRIMARY]

CREATE TABLE [dbo].[TermsUpdateHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NOT NULL,
	[notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updatedate] [datetime] NOT NULL CONSTRAINT [DF_TermsUpdateHistory_updatedate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TermsUpdateHistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[TermsByModClassHistory](
	[termid] [int] NOT NULL,
	[modclassid] [int] NOT NULL,
	[actionid] [tinyint] NOT NULL,
	[updateid] [int] NOT NULL
) ON [PRIMARY]
',
N'Terms filter denormalisation and auditing', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {A204C925-199C-4279-A920-5E9C7D70C64F}', 
N'
ALTER TABLE [dbo].[TermsByModClass]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClass_ModerationClass] FOREIGN KEY([modclassid])
REFERENCES [dbo].[ModerationClass] ([ModClassID])

ALTER TABLE [dbo].[TermsByModClass] CHECK CONSTRAINT [FK_TermsByModClass_ModerationClass]

ALTER TABLE [dbo].[TermsByModClass]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClass_TermsActionLookup] FOREIGN KEY([actionid])
REFERENCES [dbo].[TermsActionLookup] ([id])

ALTER TABLE [dbo].[TermsByModClass] CHECK CONSTRAINT [FK_TermsByModClass_TermsActionLookup]

ALTER TABLE [dbo].[TermsByModClass]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClass_TermsLookup] FOREIGN KEY([termid])
REFERENCES [dbo].[TermsLookup] ([id])

ALTER TABLE [dbo].[TermsByModClass] CHECK CONSTRAINT [FK_TermsByModClass_TermsLookup]

ALTER TABLE [dbo].[TermsByModClassHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClassHistory_ModerationClass] FOREIGN KEY([modclassid])
REFERENCES [dbo].[ModerationClass] ([ModClassID])

ALTER TABLE [dbo].[TermsByModClassHistory] CHECK CONSTRAINT [FK_TermsByModClassHistory_ModerationClass]

ALTER TABLE [dbo].[TermsByModClassHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClassHistory_TermsActionLookup] FOREIGN KEY([actionid])
REFERENCES [dbo].[TermsActionLookup] ([id])

ALTER TABLE [dbo].[TermsByModClassHistory] CHECK CONSTRAINT [FK_TermsByModClassHistory_TermsActionLookup]

ALTER TABLE [dbo].[TermsByModClassHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClassHistory_TermsLookup] FOREIGN KEY([termid])
REFERENCES [dbo].[TermsLookup] ([id])

ALTER TABLE [dbo].[TermsByModClassHistory] CHECK CONSTRAINT [FK_TermsByModClassHistory_TermsLookup]

ALTER TABLE [dbo].[TermsByModClassHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByModClassHistory_TermsUpdateHistory] FOREIGN KEY([updateid])
REFERENCES [dbo].[TermsUpdateHistory] ([id])

ALTER TABLE [dbo].[TermsByModClassHistory] CHECK CONSTRAINT [FK_TermsByModClassHistory_TermsUpdateHistory]
', 
N'Foreign key relationships for terms tables', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: A204C925-199C-4279-A920-5E9C7D70C647', 
	N'
		
		insert into TermsLookup 
		select ''cows'' union all select ''pig'' union all select ''horse'' union all select ''chicken'' union all select ''粪''
		
		insert into TermsByModClass (termid, modclassid, actionid) values (1,1,2)
		insert into TermsByModClass (termid, modclassid, actionid) values (2,1,2)
		insert into TermsByModClass (termid, modclassid, actionid) values (3,1,1)
		insert into TermsByModClass (termid, modclassid, actionid) values (4,1,1)
		insert into TermsByModClass (termid, modclassid, actionid) values (5,1,1)
		
		insert into TermsByModClass (termid, modclassid, actionid) values (1,2,2)
		insert into TermsByModClass (termid, modclassid, actionid) values (2,2,1)
		insert into TermsByModClass (termid, modclassid, actionid) values (3,2,1)
		insert into TermsByModClass (termid, modclassid, actionid) values (4,2,1)
		insert into TermsByModClass (termid, modclassid, actionid) values (5,2,1)
		
	', 
	N'Terms test data', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: B204C925-199C-4279-A920-5E9C7D70C647', 
	N'
		insert into TermsLookup
		select distinct(profanity)
		from 
			profanities
		where 
			profanity not in
			( 
				select 
					term 
				from 
					TermsLookup
			)
	

		insert into TermsByModClass
		select 
			t.id as termid,
			p.modclassid as modclassid,
			case when p.refer = 1 then 1 else 2 end as actionid
		from
			profanities p
			inner join termslookup t on t.term = p.profanity
			inner join moderationclass mc on mc.modclassid = p.modclassid --added for data integrity - ensure that profanities only contains valid modclassids
		
	', 
	N'Migrate existing Profanities to terms', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'Markn: 487BD779-D3DC-4FD6-802B-EA39CA2D8D70',
N'
CREATE NONCLUSTERED INDEX [IX_Threads_LastUpdated] ON [dbo].[Threads] 
(
	[ForumID] ASC,
	[LastUpdated] ASC
)
',
N'Creating [IX_Threads_LastUpdated] on threads to speed up forumgetthreadlist', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'mrh: 3D14284A-B44B-44A6-A444-AF4F5542C64a', 
N'
IF NOT EXISTS ( SELECT * FROM SiteOptions WHERE SiteID = 0 AND Section = ''SignIn'' AND Name = ''CollectExtraDetails'')
BEGIN
	INSERT INTO dbo.SiteOptions SELECT Section = ''SignIn'', SiteID = 0, Name = ''CollectExtraDetails'', Value = '''', Type = 2, Description = ''Set the policy for collecting extra user details''
END
', 
N'Insert new collect extra sign in details site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'mrh: 3D23284A-B423-4423-A444-AF235542C64a', 
N'
IF NOT EXISTS ( SELECT * FROM SiteOptions WHERE SiteID = 0 AND Section = ''User'' AND Name = ''UseSiteSuffix'')
BEGIN
	INSERT INTO dbo.SiteOptions SELECT Section = ''User'', SiteID = 0, Name = ''UseSiteSuffix'', Value = ''0'', Type = 1, Description = ''Set this for sites that use SiteSuffix instead of Username''
END
', 
N'Insert new USe Site Suffix site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

DELETE FROM dbo.admin_dbchanges WHERE UID = 'mrh: 3414234A-B34B-4434-A344-AF34542C64a'

EXEC dbu_dosql N'mrh: 3414234A-B34B-4434-A344-AF34542C64a123', 
N'
IF NOT EXISTS ( SELECT * FROM SiteOptions WHERE SiteID = 0 AND Section = ''User'' AND Name = ''AutoGeneratedNames'')
BEGIN
	INSERT INTO dbo.SiteOptions SELECT Section = ''User'', SiteID = 0, Name = ''AutoGeneratedNames'', Value = '''', Type = 2, Description = ''Set this to the URL of the API that generates the names''
END
', 
N'Insert new AutoGenerated names site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN
/*
IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'mrh: 3414564A-B356-4456-A356-AF56542C64a', 
	N'
		UPDATE SiteOptions SET Value=''1'' WHERE SiteID = 0 AND Name=''UseIdentitySignIn''
		UPDATE Sites SET IdentityPolicy=''http://identity/policies/dna/adult''
		UPDATE Sites SET IdentityPolicy=''http://identity/policies/dna/over13'' WHERE UrlName=''mbblast''
		UPDATE Sites SET IdentityPolicy=''http://identity/policies/dna/kids'' WHERE UrlName=''mbcbbc''
		UPDATE Sites SET IdentityPolicy=''http://identity/policies/dna/schools'' WHERE UrlName=''mbnewsround''
	', 
	N'Updated Small Guide to use IDentity for all sites', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END
*/
EXEC dbu_dosql N'SFP: D9B4294D-47A3-414E-8BF0-02BDD24A27E4',
N'
CREATE NONCLUSTERED INDEX [IX_Forums_SiteIDLastPosted] ON [dbo].[Forums] 
(
	[SiteID] ASC,
	[LastPosted] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
',
N'Creating [IX_Forums_SiteIDLastPosted] on forums to speed up CommentsReadBySiteName sorted by lastposted', @curerror OUTPUT
IF (@curerror <> 0) RETURN

declare @siteid int
select @siteid = siteid from Sites where urlname = 'iplayertv'
if (@siteid is not null)
begin
	EXEC dbu_dosql 
	N'DJW: 6BD1E80F-4227-42aa-82E6-3C5E730A369A',
	N'
	declare @siteid int
	select @siteid = siteid from Sites where urlname = ''iplayertv''
	if not exists(select * from snesapplicationmetadata where siteid = @siteid)
	begin
		insert into snesapplicationmetadata (siteid, applicationid, applicationname) 
		values (@siteid, ''iPlayerTV'', ''BBC iPlayer Recommendations'')
	end',
	
	N'Adding iplayertv metadata to SnesApplicationMetadata table',
	@curerror OUTPUT
	IF (@curerror <> 0) RETURN
end

EXEC dbu_dosql N'mrh: 3D23284A-B423-0000-0000-AF235542C64a', 
N'
IF NOT EXISTS ( SELECT * FROM SiteOptions WHERE SiteID = 0 AND Section = ''General'' AND Name = ''BarlequeMessageboard'')
BEGIN
	INSERT INTO dbo.SiteOptions SELECT Section = ''General'', SiteID = 0, Name = ''BarlequeMessageboard'', Value = ''0'', Type = 1, Description = ''Enable this if your site is based on the new barleque messageboard skins''
END
', 
N'Insert new BarlequeMessageboard site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 333330F4-CADC-33FD-B608-Bddddddd3AD3',
N'DECLARE @type varchar(255)
SET @type = dbo.udf_getcolumntype(''Users'',''Username'')
IF @type IS NULL RAISERROR (''Failed to find type for column Username in Users table'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''Users table has not been converted to Unicode for Usernames.  Run script Convert Users Usernames to Unicode.sql'',16,1)
END',
N'Checking that Users Usernames have been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: EA70D964-46A1-4f93-B67C-65E1B77DB47E', 
	N'
	--ProfileAPITest
	update SignInUserIDMapping
	set IdentityUserID = 6041996
	where dnauserid=1090498911

	--DotNetNormalUser
	update SignInUserIDMapping
	set IdentityUserID = 6042002
	where dnauserid=1090501859

	--DotNetUserBanned
	update SignInUserIDMapping
	set IdentityUserID = 6042004
	where dnauserid=1165333426

	--DotNetEditor
	update SignInUserIDMapping
	set IdentityUserID = 6042008
	where dnauserid=1090558353

	--DotNetSuperUser
	update SignInUserIDMapping
	set IdentityUserID = 6042010
	where dnauserid=1090558354

	--DotNetModerator
	update SignInUserIDMapping
	set IdentityUserID = 6042012
	where dnauserid=1090564231

	--DotNetPreModUser
	update SignInUserIDMapping
	set IdentityUserID = 6042014
	where dnauserid=1090565871

	--DotNetNotableUser
	update SignInUserIDMapping
	set IdentityUserID = 6042020
	where dnauserid=1165233424
	', 
	N'Migrate smallguide test users to identity accounts.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: 4D23284A-B423-0000-0000-AF235542C64b', 
	N'
	update sites
	set identitypolicy = ''http://identity/policies/dna/adult''
	where identitypolicy is null


	update sites
	set identitypolicy = ''http://identity/policies/dna/blast''
	where urlname in
	(''slink'',
	''mbblast'',
	''blog349'')


	update sites
	set identitypolicy = ''http://identity/policies/dna/kids''
	where urlname in
	(
	''cbbc'',
	''mbcbbc'',
	''mbnewsround'',
	''u16blogs'')

	update sites
	set identitypolicy = ''http://identity/policies/dna/over13''
	where urlname in
	(
	''mbgcsebitesize'')

	update sites
	set identitypolicy = ''http://identity/policies/dna/schools''
	where urlname in
	(
	''mbstudentlife'',
	''mbks3bitesize'')


	update siteoptions
	set value=1
	where siteid=0
	and name=''UseIdentitySignIn''

	delete siteoptions
	where siteid <> 0
	and name=''UseIdentitySignIn''
	', 
	N'Convert sites to identity with relevant policies.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MRH: 44440F4-CADC-33FD-B608-Brrrrrrrr3AD3',
N'DECLARE @type varchar(255)
SET @type = dbo.udf_getcolumntype(''NicknameMod'',''NickName'')
IF @type IS NULL RAISERROR (''Failed to find type for column NickName in NicknameMod table'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''Users table has not been converted to Unicode for Usernames.  Run script Convert NickNameMod-Username to Unicode.sql'',16,1)
END',
N'Checking that NicknameMod NickName have been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'SPF: {G15C9295-241E-4EAF-A18A-26DF70BD96E0}',
N'exec dbu_createsiteoption 0, ''CommentForum'', ''EnforceSecurePosting'', ''0'' ,0,''Enforces the postings to comments api''',
N'Creating SiteOption EnforceSecurePosting', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'SPF: {h15C9295-241E-4EAF-A18A-26DF70BD96E0}',
	N'
		update SiteOptions
		set value=''1''
		where Name= ''EnforceSecurePosting''
		and Section=''CommentForum''
	',
	N'Set the siteoption EnforceSecurePosting to on for smallguide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END


IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: {h15C9295-541E-4EAF-A18A-26DF70BD96E0}',
	N'
		insert into emailtemplates
		select 
		''From: ++**nickname**++'' as subject,
		''Complaint From: ++**nickname**++  Moderation Reference: ++**reference_number**++ about ++**content_type**++ ++**content_subject**++  ++**inserted_text**++'' as Body,
		''UserComplaintEmail'' as Name,
		modclassid as ModClassId,
		0 as autoformat
		from moderationclass
	',
	N'Add email templates for email sending', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END


EXEC dbu_dosql N'Markn: D95542F5-E626-4AE3-9ED3-F348C90F53E0',
N'
IF dbo.udf_tableexists(''BBCDivision'') = 0
BEGIN
	CREATE TABLE BBCDivision
	(
		BBCDivisionId	SMALLINT IDENTITY(0,1) NOT NULL CONSTRAINT PK_BBCDivisionId PRIMARY KEY CLUSTERED,
		BBCDivisionName	NVARCHAR(50) NOT NULL
	)

	INSERT BBCDivision VALUES(''Undefined'')	-- Undefined should have id 0
	INSERT BBCDivision VALUES(''Audio and Music'')
	INSERT BBCDivision VALUES(''Vision'')
	INSERT BBCDivision VALUES(''FM&T'')
	INSERT BBCDivision VALUES(''World Service'')
	INSERT BBCDivision VALUES(''Journalism'')
END
',
N'Creating and populating table BBCDivision', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: D95542F5-E626-4AE3-9ED3-F348C90F53E1',
N'
IF dbo.udf_columnexists(''Sites'',''BBCDivisionId'')=0
BEGIN
	ALTER TABLE dbo.Sites 
		ADD BBCDivisionId smallint NOT NULL
		CONSTRAINT DF_Sites_BBCDivisionId DEFAULT 0 -- 0 means Undefined
END
',
N'Adding BBCDivisionId column to Sites table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SteveF: 45AB592D-F21F-4b3c-AC70-ECDD4DF1993A',
N'
	IF dbo.udf_indexexists (''SignInUserIDMapping'', ''CIX_SignInUserIDMappingSSOUserID'') = 1
	BEGIN
		DROP INDEX [CIX_SignInUserIDMappingSSOUserID] ON [dbo].[SignInUserIDMapping]	
	END
		
	IF dbo.udf_indexexists (''SignInUserIDMapping'', ''IX_SignInUserIDMappingIdentityUserID'') = 1
	BEGIN
		DROP INDEX [IX_SignInUserIDMappingIdentityUserID] ON [dbo].[SignInUserIDMapping]
	END	
	
	IF dbo.udf_indexexists (''SignInUserIDMapping'', ''CIX_SignInUserIDMapping'') = 1
	BEGIN
		DROP INDEX [CIX_SignInUserIDMapping] ON [dbo].[SignInUserIDMapping]
	END	
	
	ALTER TABLE dbo.SignInUserIDMapping ALTER COLUMN IdentityUserID VARCHAR(40);
	
	ALTER TABLE dbo.SignInUserIDMapping ADD CONSTRAINT UNQ_SignInUserIDMapping_IdentityUserID_DnaUserId UNIQUE (IdentityUserID,DnaUserId)	

	CREATE CLUSTERED INDEX CIX_SignInUserIDMappingIdentityUserID ON dbo.SignInUserIDMapping (IdentityUserID ASC)

	CREATE INDEX IX_SignInUserIDMappingSSOUserID ON dbo.SignInUserIDMapping(SSOUserID)

',
N'Change IdentityUserID to varchar(40) in SignInUserIDMapping table', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'Markh: 665566F5-6626-66E3-66D3-F346690F53E1',
N'
	UPDATE dbo.Preferences SET PrefSkin = NULL WHERE UserID = 0
',
N'Setting UserID=0 PrefSkin preferences to NULL for all sites', @curerror OUTPUT

IF (@curerror <> 0) RETURN
EXEC dbu_dosql N'Markh: 775577F5-7726-77E3-77D3-F347790F53E1',
N'
	UPDATE dbo.Preferences SET PrefSkin = NULL WHERE SiteID > 1
',
N'Setting all users PrefSkin preferences to NULL for all sites OTHER THAN H2G2', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {ABCC9295-241E-4EAF-A18A-26DF70BD96E0}',
N'exec dbu_createsiteoption 0, ''General'', ''CustomBarlesquePath'', '''' ,2,''The path to the custom Barlesque location to be used for this site''',
N'Creating SiteOption CustomBarlesquePath', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql 
N'MAP: 79D1E80F-4227-42aa-82E6-3C5E730A369A',
N'
declare @siteid int
select @siteid = siteid from Sites where urlname = ''iplayerradio''
if @siteid is not null and not exists(select * from snesapplicationmetadata where siteid = @siteid)
begin
	insert into snesapplicationmetadata (siteid, applicationid, applicationname) 
	values (@siteid, ''iPlayerRadio'', ''BBC iPlayer Radio Recommendations'')
end',

N'Adding iplayerradio metadata to SnesApplicationMetadata table',
@curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C990',
N'
CREATE TABLE [dbo].[BIEventQueue](
	[EventID] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_BIEventQueue PRIMARY KEY CLUSTERED,
	[EventType] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemType] [int] NOT NULL,
	[ItemID2] [int] NOT NULL,
	[ItemType2] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventUserID] [int] NOT NULL
) ON [PRIMARY]
',
N'Creating table BIEventQueue', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C991',
N'
	EXEC sp_rename ''dbo.ThreadEntryQueue'', ''ThreadPostingsQueue'';
',
N'Renaming table ThreadEntryQueue to ThreadPostingsQueue, because that''s what it''s used for', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C992',
N'
	ALTER TABLE dbo.Sites ADD CONSTRAINT CHK_Sites_QueuePostings CHECK (QueuePostings=0)
',
N'Adding a constraint to the QueuePostings column in Sites so that queuing cannot be accidentally turned on, because the feature will not currently work', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C993',
N'
	DROP PROCEDURE getaforumgroupalertid
',
N'Dropping this proc because it''s been renamed as getforumgroupalertid', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C994',
N'
CREATE TABLE RiskModerationState
(
	Id				INT		NOT NULL,
	IdType			CHAR(1) NOT NULL CONSTRAINT CHK_RiskModerationState_IdType  CHECK(IdType = ''S'' OR IdType = ''F'' OR IdType = ''T'' OR IdType = ''G''),
	IsOn			BIT		NOT NULL,
	PublishMethod	CHAR(1) NOT NULL CONSTRAINT CHK_RiskModerationState_PublishMethod  CHECK(PublishMethod = ''A'' OR PublishMethod = ''B'')
)

CREATE UNIQUE CLUSTERED INDEX CIX_RiskModerationState ON RiskModerationState(Id,IdType)

CREATE TABLE RiskModerationStateHelp
(
	HelpText VARCHAR(500)
)
INSERT RiskModerationStateHelp VALUES(''IdType = S means Site'')
INSERT RiskModerationStateHelp VALUES(''IdType = F meas Forum'')
INSERT RiskModerationStateHelp VALUES(''IdType = T means Thread'')
INSERT RiskModerationStateHelp VALUES(''IdType = G means GuideEntry'')
INSERT RiskModerationStateHelp VALUES(''PublishMethod = A means publish after a risk assessment'')
INSERT RiskModerationStateHelp VALUES(''PublishMethod = B means publish before a risk assessment'')
',
N'Creating tables RiskModerationState and RiskModerationStateHelp', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C995',
N'
CREATE TABLE RiskModThreadEntryQueue (
	RiskModThreadEntryQueueId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_RiskModThreadEntryQueue PRIMARY KEY CLUSTERED,
	ThreadEntryId int NULL,
	PublishMethod char(1) NOT NULL,
	IsRisky bit NULL,
	SiteId int NOT NULL,
	ForumId int NOT NULL,
	ThreadId int NULL,
	UserId int NOT NULL,
	UserName nvarchar(255) NULL,
	InReplyTo int NULL,
	[Subject] nvarchar(255) NOT NULL,
	Text nvarchar(max) NOT NULL,
	DatePosted datetime NOT NULL,
	PostStyle tinyint NOT NULL,
	[Hash] uniqueidentifier NOT NULL, 
	IPAddress varchar(25) NULL,
	BBCUID uniqueidentifier NULL,
	KeyWords varchar(255) NULL, 
	[Type] varchar(30) NULL,
	EventDate datetime NULL,
	AllowEventEntries tinyint NOT NULL, 
	NodeId int NOT NULL, 
	QueueId int NULL, 
	ClubId int NOT NULL, 
	IsNotable tinyint NOT NULL, 
	IsComment tinyint NOT NULL,
	ModNotes VARCHAR(255) NULL,
	IsThreadedComment tinyint NOT NULL
)

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_Threads] FOREIGN KEY([ThreadId])
REFERENCES [dbo].[Threads] ([ThreadId])

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_ForumId] FOREIGN KEY(ForumId)
REFERENCES [dbo].Forums (ForumId)
',
N'Creating table RiskModThreadEntryQueue', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C996',
N'
ALTER TABLE dbo.PreModPostings ADD RiskModThreadEntryQueueId int NULL
',
N'Adding RiskModThreadEntryQueueId column to dbo.PreModPostings table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn: 3C768872-30AE-403F-8E9D-12F16B27C997',
N'
DROP TABLE RiskModThreadEntryQueue

CREATE TABLE RiskModThreadEntryQueue (
	RiskModThreadEntryQueueId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_RiskModThreadEntryQueue PRIMARY KEY CLUSTERED,
	ThreadEntryId int NULL,
	PublishMethod char(1) NOT NULL,
	IsRisky bit NULL,
	DateAssessed DateTime NULL,
	SiteId int NOT NULL,
	ForumId int NOT NULL,
	ThreadId int NULL,
	UserId int NOT NULL,
	UserName nvarchar(255) NULL,
	InReplyTo int NULL,
	[Subject] nvarchar(255) NOT NULL,
	Text nvarchar(max) NOT NULL,
	DatePosted datetime NOT NULL,
	PostStyle tinyint NOT NULL,
	[Hash] uniqueidentifier NOT NULL, 
	IPAddress varchar(25) NULL,
	BBCUID uniqueidentifier NULL,
	KeyWords varchar(255) NULL, 
	[Type] varchar(30) NULL,
	EventDate datetime NULL,
	AllowEventEntries tinyint NOT NULL, 
	NodeId int NULL, 
	QueueId int NULL, 
	ClubId int NULL, 
	IsNotable tinyint NOT NULL, 
	IsComment tinyint NOT NULL,
	ModNotes VARCHAR(255) NULL,
	IsThreadedComment tinyint NOT NULL
)

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_Threads] FOREIGN KEY([ThreadId])
REFERENCES [dbo].[Threads] ([ThreadId])

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])

ALTER TABLE RiskModThreadEntryQueue  WITH CHECK ADD  CONSTRAINT [FK_RiskModThreadEntryQueue_ForumId] FOREIGN KEY(ForumId)
REFERENCES [dbo].Forums (ForumId)
',
N'Recreating table RiskModThreadEntryQueue with new DateAssessed column, and nullable ClubId and NodeId columns', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {2E0DE586-80F9-4865-AAFF-5BF1236FB94E}',
N'
/*
0 - Undefined
1 - Blog
2 - Messageboard
3 - Community - h2g2, memoryshare
4 - EmbeddedComments
*/

-- delete all site options
delete from SiteOptions where [Name] = ''SiteType''

-- Create a siteType record with an ''undefined'' value for each site
;with blogSites as 
(
	select 
		siteid as siteid,
		''General'' as Section,
		''SiteType'' as [Name],
		''0'' as [Value],	-- 0 = Undefined
		0 as [Type], -- int
		''Site type'' as Description
	from sites s
	
)
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
SELECT siteid, Section, [Name], [Value], [Type], Description
FROM blogSites


-- Update Blogs
 UPDATE
	so
 SET
	so.[Value] = ''1''
 FROM
	sites s
	inner join  SiteOptions as so on so.siteid = s.siteid
 WHERE 
	(s.UrlName like ''blog%''  or s.ShortName like ''%blog%'')
	and so.[Name] = ''SiteType''


-- Update Messageboards
 UPDATE
	so
 SET
	so.[Value] = ''2''
 FROM
	sites s
	inner join  SiteOptions as so on so.siteid = s.siteid
 WHERE 
	so.[Name] = ''SiteType''
	and  so.siteid in (select siteid from SiteOptions where [Name] = ''IsMessageboard'' and [Value] = 1)


-- Update Community
 UPDATE
	so
 SET
	so.[Value] = ''3''
 FROM
	sites s
	inner join  SiteOptions as so on so.siteid = s.siteid
 WHERE 
	so.[Name] = ''SiteType'' 
	and (s.[ShortName] = ''h2g2'' or s.[ShortName] = ''collective'' or s.[ShortName] = ''memoryshare'')


-- Update Embedded Comments (only assigned if site doesn''t already have a SiteType)
 UPDATE
	so
 SET
	so.[Value] = ''4''
 FROM
	sites s
	inner join  SiteOptions as so on so.siteid = s.siteid
 WHERE 
	so.[Name] = ''SiteType'' 
	and (so.[Value] = ''0'' and s.description like ''%comments%'' )


declare @haveyoursayID int
select @haveyoursayID = siteid from sites where urlname = ''haveyoursay''
update SiteOptions set  [Value] = ''4'' where siteid = @haveyoursayID and [Name] = ''SiteType''

',
N'
create site option entries called SiteType
', @curerror OUTPUT

EXEC dbu_dosql N'SteveF: C42A8E93-F4CE-468f-B08A-7E578A341D90',
N'
	CREATE INDEX IX_UsersLoginName ON dbo.Users(LoginName)
',
N'Add index IX_UsersLoginName to IX_UsersLoginName table', @curerror OUTPUT
IF (@curerror <> 0 ) RETURN

EXEC dbu_dosql N'MAP: {ABCC9296-241E-4EAF-A18A-26DF70BD96E0}',
N'exec dbu_createsiteoption 0, ''General'', ''SiteLanguage'', ''en'' ,2,''See currently supported codes at <href="https://confluence.dev.bbc.co.uk/display/DNA/Supported+Language+Codes">https://confluence.dev.bbc.co.uk/display/DNA/Supported+Language+Codes</a>''',
N'Creating SiteOption SiteLanguage', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {ABCC9297-241E-4EAF-A18A-26DF70BD96E1}',
N'
	ALTER TABLE dbo.ModerationClass ADD
	ClassLanguage nvarchar(10) NOT NULL CONSTRAINT DF_ModerationClass_ClassLanguage DEFAULT N''en''
',
N'Alter moderationclass table to accept a language code', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 55520055-CA55-4355-B655-BD55580E5550',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''EmailTemplates'',''Body'')
IF @type IS NULL RAISERROR (''Failed to find type for column Body in the EmailTemplates Table'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	RAISERROR (''EmailTemplates has not been converted to Unicode.  Run script Convert EmailTemplates and Insert to Unicode.sql int the DBScripts folder.'',16,1)
END',
N'Checking that EmailTemplates has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {FBCC9297-241E-4EAF-A18A-26DF70BD96E5}',
N'
	CREATE TABLE [dbo].[UserPrefStatusAudit](
	[UserUpdateId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Updated] [datetime] NOT NULL CONSTRAINT [DF_UserPrefStatusAudit_Updated]  DEFAULT (getdate()),
	[Reason] [nvarchar](max),
	[DeactivateAccount] [bit] NOT NULL,
	[HideContent] [bit] NOT NULL,
	 CONSTRAINT [PK_UserPrefStatusAudit] PRIMARY KEY CLUSTERED 
	(
		[UserUpdateId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	ALTER TABLE [dbo].[UserPrefStatusAudit]  WITH CHECK ADD  CONSTRAINT [FK_UserPrefStatusAudit_UserPrefStatusAudit] FOREIGN KEY([UserUpdateId])
	REFERENCES [dbo].[UserPrefStatusAudit] ([UserUpdateId])

	ALTER TABLE [dbo].[UserPrefStatusAudit] CHECK CONSTRAINT [FK_UserPrefStatusAudit_UserPrefStatusAudit]

	ALTER TABLE [dbo].[UserPrefStatusAudit]  WITH CHECK ADD  CONSTRAINT [FK_UserPrefStatusAudit_Users] FOREIGN KEY([UserId])
	REFERENCES [dbo].[Users] ([UserID])

	ALTER TABLE [dbo].[UserPrefStatusAudit] CHECK CONSTRAINT [FK_UserPrefStatusAudit_Users]

	CREATE TABLE [dbo].[UserPrefStatusAuditActions](
		[UserUpdateId] [int] NOT NULL,
		[SiteId] [int] NOT NULL,
		[UserId] [int] NOT NULL,
		[PreviousPrefStatus] [int] NOT NULL,
		[NewPrefStatus] [int] NOT NULL,
		[PrefDuration] [int] NOT NULL,
	 CONSTRAINT [PK_UserPrefStatusAuditActions] PRIMARY KEY CLUSTERED 
	(
		[UserUpdateId] ASC,
		[SiteId] ASC,
		[UserId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

',
N'Audit tables for user preference changes', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {ABCC9296-AAAA-4EAF-A18A-26DF70BD96E0}',
N'
exec dbu_createsiteoption 0, ''SNeS Integration'', ''Enabled'', ''0'' ,1,''Whether to propogate content to SNeS - note SiteIsPrivate is also honoured''
exec dbu_createsiteoption 0, ''SNeS Integration'', ''ObjectUriFormat'', ''bbc:dna:{forumid}:{threadid}:{postid}'' ,2,''Format of the object URI sent to SNeS - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid}''
exec dbu_createsiteoption 0, ''SNeS Integration'', ''ContentPermaUrl'', '''' ,2,''Format of the permalink - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid} - empty means standard dna url''
exec dbu_createsiteoption 0, ''SNeS Integration'', ''CustomActivityType'', '''' ,2,''ActivityType sent through to SNeS - empty uses default value for type of content''

--set iplayertv values
declare @iplayerTv int
select @iplayerTv = siteid from sites where urlname = ''iplayertv''
if @iplayerTv <> 0 or @iplayerTv is not null
begin

	exec dbu_createsiteoption @iplayerTv, ''SNeS Integration'', ''Enabled'', ''1'' ,1,''Whether to propogate content to SNeS - note SiteIsPrivate is also honoured''
	exec dbu_createsiteoption @iplayerTv, ''SNeS Integration'', ''ObjectUriFormat'', ''bbc:programme:{commentforumuid}'' ,2,''Format of the object URI sent to SNeS - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid}''
	exec dbu_createsiteoption @iplayerTv, ''SNeS Integration'', ''CustomActivityType'', ''recommend_comment'' ,2,''ActivityType sent through to SNeS''
end

--set iplayerradio values
declare @iplayerRadio int
select @iplayerRadio = siteid from sites where urlname = ''iplayerradio''
if @iplayerRadio <> 0 or @iplayerRadio is not null
begin

	exec dbu_createsiteoption @iplayerRadio, ''SNeS Integration'', ''Enabled'', ''1'' ,1,''Whether to propogate content to SNeS - note SiteIsPrivate is also honoured''
	exec dbu_createsiteoption @iplayerRadio, ''SNeS Integration'', ''ObjectUriFormat'', ''bbc:programme:{commentforumuid}'' ,2,''Format of the object URI sent to SNeS - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid}''
	exec dbu_createsiteoption @iplayerRadio, ''SNeS Integration'', ''CustomActivityType'', ''recommend_comment'' ,2,''ActivityType sent through to SNeS''
end

',
N'Creating SNeS Integration Siteoptions', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {ABCC9296-241G-4EAF-A18A-26DF70BD96F0}',
N'exec dbu_createsiteoption 0, ''Forum'', ''EnableSearch'', ''0'' ,1,''Whether to show search links or not''',
N'Creating SiteOption search enabled for skins', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {ZXYC9296-241G-4EAF-A18A-26DF70BD96F0}',
N'
CREATE TABLE [dbo].[DatabaseConfig](
	[server] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
',
N'Creating DatabaseConfig table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SPF: {8D7087D3-930C-4b97-92FC-D9A0B4A1BA93}',
N'
CREATE TABLE dbo.BRAlteredEntries
(
    EntryID INT
);

WITH AfflictedEntries AS
(
	SELECT EntryID, Text FROM GuideEntries WHERE Text LIKE ''%<BR>%'' OR Text LIKE ''%</BR>%'' AND SiteID = 1
)
UPDATE AfflictedEntries SET Text=REPLACE(REPLACE(Text,''<BR>'',''<BR/>''),''</BR>'','''') OUTPUT Inserted.EntryID INTO dbo.BRAlteredEntries
',
N'Replacing <BR> <br> with <BR/> and removing </br> </BR> tags', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {ZXYC9296-267G-4EAF-A18A-26DF70BD96F0}',
N'
CREATE TABLE [dbo].[SiteDailySummaryReport](
	[Date] [datetime] NOT NULL,
	[SiteId] [int] NOT NULL,
	[TotalModerations] [int] NOT NULL,
	[TotalReferredModerations] [int] NOT NULL,
	[TotalComplaints] [int] NOT NULL,
	[UniqueModerationUsers] [int] NOT NULL,
	[TotalNotablePosts] [int] NOT NULL,
	[TotalHostPosts] [int] NOT NULL,
	[TotalPosts] [int] NOT NULL,
	[TotalExLinkModerations] [int] NOT NULL,
	[TotalExLinkReferrals] [int] NOT NULL,
	[TotalExLinkModPasses] [int] NOT NULL,
	[TotalExLinkModFails] [int] NOT NULL,
	[TotalPostsFailed] [int] NOT NULL,
	[TotalNewUsers] [int] NOT NULL,
	[TotallBannedUsers] [int] NOT NULL,
	[TotalNickNamesModerations] [int] NOT NULL,
 CONSTRAINT [PK_SiteDailySummaryReport] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SiteDailySummaryReport]  WITH CHECK ADD  CONSTRAINT [FK_SiteDailySummaryReport_Sites] FOREIGN KEY([SiteId])
REFERENCES [dbo].[Sites] ([SiteID])

ALTER TABLE [dbo].[SiteDailySummaryReport] CHECK CONSTRAINT [FK_SiteDailySummaryReport_Sites]
',
N'Creating SiteDailySummaryReport table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {92E88805-4D55-5b75-9EA1-5AC2B7DBD425}',
N'

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_SiteActivityItems_SiteActivityTypes]'') AND parent_object_id = OBJECT_ID(N''[dbo].[SiteActivityItems]''))
ALTER TABLE [dbo].[SiteActivityItems] DROP CONSTRAINT [FK_SiteActivityItems_SiteActivityTypes]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_SiteActivityItems_Sites]'') AND parent_object_id = OBJECT_ID(N''[dbo].[SiteActivityItems]''))
ALTER TABLE [dbo].[SiteActivityItems] DROP CONSTRAINT [FK_SiteActivityItems_Sites]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[SiteActivityTypes]'') AND type in (N''U''))
DROP TABLE [dbo].[SiteActivityTypes]

CREATE TABLE [dbo].[SiteActivityTypes](
	[activitytype] [int] NOT NULL,
	[description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_SiteActivityTypes] PRIMARY KEY CLUSTERED 
(
	[activitytype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[SiteActivityItems]'') AND type in (N''U''))
DROP TABLE [dbo].[SiteActivityItems]

CREATE TABLE [dbo].[SiteActivityItems](
	[type] [int] NOT NULL,
	[activitydata] [xml] NOT NULL,
	[datetime] [datetime] NOT NULL,
	[siteId] [int] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_SiteActivityItems] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SiteActivityItems]  WITH CHECK ADD  CONSTRAINT [FK_SiteActivityItems_SiteActivityTypes] FOREIGN KEY([type])
REFERENCES [dbo].[SiteActivityTypes] ([activitytype])

ALTER TABLE [dbo].[SiteActivityItems] CHECK CONSTRAINT [FK_SiteActivityItems_SiteActivityTypes]

ALTER TABLE [dbo].[SiteActivityItems]  WITH CHECK ADD  CONSTRAINT [FK_SiteActivityItems_Sites] FOREIGN KEY([siteId])
REFERENCES [dbo].[Sites] ([SiteID])

ALTER TABLE [dbo].[SiteActivityItems] CHECK CONSTRAINT [FK_SiteActivityItems_Sites]

CREATE NONCLUSTERED INDEX [IX_SiteActivityItems_datetime] ON [dbo].[SiteActivityItems] 
(
	[datetime] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]


',
N'Creating site activity tables', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {92F88805-4D55-4b75-9EA1-5AC2B7DBD427}',
N'
delete from SiteActivityTypes
insert into SiteActivityTypes values (1,''Moderate Post Failed'')
insert into SiteActivityTypes values (2,''Moderate Post Referred'')
insert into SiteActivityTypes values (3,''Moderate Article Failed'')
insert into SiteActivityTypes values (4,''Moderate Article Referred'')
insert into SiteActivityTypes values (5,''Moderate ExLink Failed'')
insert into SiteActivityTypes values (6,''Moderate Exlink Referred'')
insert into SiteActivityTypes values (7,''Complaint Post'')
insert into SiteActivityTypes values (8,''Complaint Article'')
insert into SiteActivityTypes values (9,''Complaint Exlink'')
insert into SiteActivityTypes values (10,''UserModerated Premod'')
insert into SiteActivityTypes values (11,''UserModerated PostMod'')
insert into SiteActivityTypes values (12,''UserModerated Banned'')
insert into SiteActivityTypes values (13,''UserModerated Deactivated'')
insert into SiteActivityTypes values (14,''NewUser To Site'')
insert into SiteActivityTypes values (15,''SiteSummary'')
',
N'Creating site activity types', @curerror OUTPUT
IF (@curerror <> 0) RETURN
	
EXEC dbu_dosql N'MAP: {{92E88805-4D55-4b75-9EA1-5AC2B7DBD414}}',
N'
CREATE TABLE [dbo].[SiteActivityQueue](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventType] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemType] [int] NOT NULL,
	[ItemID2] [int] NOT NULL,
	[ItemType2] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventUserID] [int] NOT NULL
) ON [PRIMARY]
',
N'Creating SiteActivityQueue table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {CE04586F-55D1-463e-AA5B-A71D8CC4CF57}',
N'
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK__ThreadMod__Actio__772F92BE]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK__ThreadMod__Actio__772F92BE]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK__ThreadMod__ModID__74532613]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK__ThreadMod__ModID__74532613]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK__ThreadMod__Reaso__763B6E85]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK__ThreadMod__Reaso__763B6E85]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK__ThreadMod__Statu__75474A4C]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK__ThreadMod__Statu__75474A4C]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK__ThreadMod__Trigg__7A0BFF69]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK__ThreadMod__Trigg__7A0BFF69]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ThreadModHistory_LockedBy]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK_ThreadModHistory_LockedBy]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''[dbo].[FK_ThreadModHistory_TriggeredBy]'') AND parent_object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]''))
ALTER TABLE [dbo].[ThreadModHistory] DROP CONSTRAINT [FK_ThreadModHistory_TriggeredBy]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[ThreadModHistory]'') AND type in (N''U''))
DROP TABLE [dbo].[ThreadModHistory]


CREATE TABLE [dbo].[ThreadModHistory](
	[ModID] [int] NOT NULL,
	[HistoryModID] [int] IDENTITY(1,1) NOT NULL,
	[EventDate] [datetime] NULL CONSTRAINT [DF_ThreadMod_EventDate]  DEFAULT (getdate()),
	[LockedBy] [int] NULL,
	[Status] [int] NULL,
	[ReasonId] [int] NULL,
	[Notes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferredBy] [int] NULL,
 CONSTRAINT [PK_ThreadModHistory_ID] PRIMARY KEY CLUSTERED 
(
	[HistoryModID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ThreadModHistory]  WITH CHECK ADD  CONSTRAINT [FK_ThreadModHistory_ThreadMod] FOREIGN KEY([ModID])
REFERENCES [dbo].[ThreadMod] ([ModID])

ALTER TABLE [dbo].[ThreadModHistory] CHECK CONSTRAINT [FK_ThreadModHistory_ThreadMod]

',
N'Creating ThreadModHistory table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {94D8C1C2-73AA-487c-BCB7-12ADAB219B77} -1',
N'
ALTER TABLE dbo.ThreadEntryEditorPicks ADD forumId int NULL

',
N'Add forum row to entries for easier count per forum', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {94D8C1C2-73AA-487c-BCB7-12ADAB219B78} -3',
N'
update threadentryeditorpicks
set forumId = ( select forumid from threadentries where threadentryeditorpicks.entryid = entryid)

ALTER TABLE dbo.ThreadEntryEditorPicks ADD CONSTRAINT
	FK_ThreadEntryEditorPicks_Forums FOREIGN KEY
	(
	forumId
	) REFERENCES dbo.Forums
	(
	ForumID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

',
N'Add forum row to entries for easier count per forum', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {94D8C1C2-73AA-487c-BCB7-12ADAB219B78} -4',
N'
CREATE NONCLUSTERED INDEX [IX_ThreadEntryEditorPicks_ForumId] ON [dbo].[ThreadEntryEditorPicks] 
(
	[forumId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]


',
N'Add forum row to entries for easier count per forum', @curerror OUTPUT
IF (@curerror <> 0) RETURN



EXEC dbu_dosql N'MAP: {94D8C1C2-73AA-487c-BCB7-12ADAB219B|AB}',
N'
ALTER TABLE dbo.SiteDailySummaryReport ADD
	TotalRestrictedUsers int NOT NULL DEFAULT 0
',
N'Extend dbo.SiteDailySummaryReport to add TotalRestrictedUsers', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Markn : BB08F296-0AED-4791-970C-7455C05B3840 - riskmod',
N'
CREATE TABLE dbo.RiskModDecisionsForThreadEntries
(
	DateAssessed datetime NOT NULL,
	SiteId int NOT NULL,
	ForumId int NOT NULL,
	ThreadEntryId int NOT NULL,
	IsRisky bit NOT NULL
)  ON [PRIMARY]

ALTER TABLE dbo.RiskModDecisionsForThreadEntries ADD CONSTRAINT
	DF_RiskModDecisionsForThreadEntries_DateAssessed DEFAULT getdate() FOR DateAssessed
	
CREATE UNIQUE CLUSTERED INDEX [CIX_RiskModDecisionsForThreadEntries] ON [dbo].[RiskModDecisionsForThreadEntries] (ThreadEntryId)
	
CREATE INDEX [IX_RiskModDecisionsForThreadEntries_DateAssessed] ON [dbo].[RiskModDecisionsForThreadEntries] (DateAssessed)
',
N'New table RiskModDecisionsForThreadEntries for recording risk mod decisions in the background', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {94D8C1C2-20101124-487c-BCB7-12ADAB210}',
N'
delete from siteoptions
where 
siteid=0
and Name=''SiteType''

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values
(0, ''General'', ''SiteType'', ''0'',0, ''The type of a site: 0 - Undefined
1 - Blog
2 - Messageboard
3 - Community - h2g2, memoryshare, 606
4 - EmbeddedComments'')
',
N'Adding default site type', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: {BLAH-BLAH-BLAH-20101124-487c-BCB7-12ADAB210}',
N'
	delete from siteoptions where siteid > 0 and Name=''UseIdentitySignIn''
',
N'Removing all UseIdentitySignIn siteoptions so that the default is true', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {3372213F-CDB5-4aa3-B156-AD1A766D31B0}',
N'
CREATE TABLE [dbo].[ThreadEntryRating](
	[entryid] [int] NOT NULL,
	[userid] [int] NOT NULL CONSTRAINT [DF_ThreadEntryRating_userid]  DEFAULT ((0)),
	[userhash] [uniqueidentifier] NOT NULL,
	[value] [smallint] NOT NULL,
	[forumid] [int] NOT NULL,
	[siteid] [int] NOT NULL
 CONSTRAINT [PK_ThreadEntryRating] PRIMARY KEY CLUSTERED 
(
	[entryid] ASC,
	[userid] ASC,
	[userhash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ThreadEntryRating]  WITH CHECK ADD  CONSTRAINT [CK_ThreadEntryRating_nerovalue] CHECK  (([value]=(1) OR [value]=(-1)))
ALTER TABLE [dbo].[ThreadEntryRating]  WITH CHECK ADD  CONSTRAINT [CK_ThreadEntryRating_ValidUser] CHECK  ((userid= 0 and userhash <> ''{00000000-0000-0000-0000-000000000000}'') or (userid<>0 and userhash=''{00000000-0000-0000-0000-000000000000}''))

',
N'Create ThreadEntryRating table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


IF DB_NAME() = 'SmallGuide'
BEGIN

EXEC dbu_dosql N'MAP: {3372213F-CDB5-4aa3-B156-AD1A766D31B1}',
N'

delete from Preferences where userid=1090501859
insert into Preferences (userid, siteid, AutoSinBin, prefstatus, AgreedTerms, DateJoined)
select 1090501859, siteid, 0, 0, 1, ''1/1/2010''
from sites
',
N'updating smallguide to allow for normal user to post to sites - adding to prefence table', @curerror OUTPUT
IF (@curerror <> 0) RETURN



END

EXEC dbu_dosql N'MAP: {9D994E40-768B-4b4c-BD79-35CD08BC95E0}',
N'

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values
(0, ''General'', ''FrontPageLocation'', '''',2, ''The builder or url for the application frontpage.'')
',
N'Adding FrontPageLocation site option', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9D994E40-768B-4b4c-BD79-35CD08BC95E1}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
select 
siteid, ''General'', ''FrontPageLocation'', ''mbfrontpage.aspx'',2, ''The builder or url for the application frontpage.''
from sites
where defaultskin = ''boards_v2''
',
N'Update migrated MB''s to use new mbfrontpage builder through siteoption', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9D994E40-768B-4b4c-BD79-45CD08BC95E1}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
select 
siteid, ''General'', ''FrontPageLocation'', ''/dna/moderation/admin/hostdashboard'',2, ''The builder or url for the application frontpage.''
from sites
where urlname = ''moderation''
',
N'Update moderation default to use the admin tool for moderation', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9D994E40-768B-4b4c-BD79-45ABC8BC95E1}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''CommentForum'', ''AllowNotSignedInCommenting'', ''0'',1, ''Whether comment forums can be used with non-signed in users.'')
',
N'Create notsignedin option for comments', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9F194E40-768B-4b4c-BD79-45ABC8BC95E1}',
N'
ALTER TABLE dbo.CommentForums ADD
	NotSignedInUserId int NOT NULL CONSTRAINT DF_CommentForums_NoSignedInUserId DEFAULT 0

',
N'Alter commentforum table to include notsignedinuserid', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {1E185E40-768B-4b4c-BD79-45ABC8BC95E1}',
N'
CREATE TABLE [dbo].[ThreadModAwaitingEmailVerification](
	[ID] [uniqueidentifier] NOT NULL,
	[ForumID] [int] NULL,
	[ThreadID] [int] NULL,
	[PostID] [int] NULL,
	[DateQueued] [datetime] NULL,
	[CorrespondenceEmail] [varchar](255) NULL,
	[ComplaintText] [text] NULL,
	[SiteID] [int] NULL,
	[IsPreModPosting] [tinyint] NULL,
	[IPAddress] [varchar](25) NULL,
	[BBCUid] [uniqueidentifier] NULL,
	[notes] [varchar](max) null,
 CONSTRAINT [PK_ThreadModAwaitingEmailVerification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

',
N'Create table to hold anonymous complaints with emails awaiting verification', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {1E185E40-8965-4b4c-BD79-45ABC8BC95E1}:1',
N'
DECLARE @strPrint VARCHAR(max)

set @strPrint =  ''Dear BBC visitor'' + char(13) + char(10) + char(13) + char(10) +
''You’ve received this email because your address has been submitted when reporting a comment or message posted on the BBC’s website.'' + char(13) + char(10) + char(13) + char(10) +
''This URL contains an activation code. Please click the link to send your complaint to the moderators.'' + char(13) + char(10) + char(13) + char(10) +
''http://www.bbc.co.uk/dna/++**urlname**++/comments/UserComplaintPage?verificationcode=++**verificationcode**++'' + char(13) + char(10) + char(13) + char(10) +  
''Complaints which have not been activated within two months may be deleted.'' + char(13) + char(10) + char(13) + char(10) +
''If you have not reported a comment or message posted on the BBC website please ignore this email. Abuse of the complaints facility will result in restriction of its use.  If you wish to block your email address from being used to complain please contact us using one of the forms listed below. Please note this will prevent you from making a genuine complaint about any comments or messages in future.'' + char(13) + char(10) + char(13) + char(10) +
''Kind regards'' + char(13) + char(10) +
''BBC Central Communities team''  + char(13) + char(10) + 
''http://www.bbc.co.uk/messageboards/''  + char(13) + char(10) + 
''http://www.bbc.co.uk/blogs'' + char(13) + char(10) + char(13) + char(10) + char(13) + char(10) + char(13) + char(10) +
''This e-mail, and any attachment, is confidential. If you have received it in error, please delete it from your system, do not use or disclose the information in any way, and notify us immediately. The contents of this message may contain personal views which are not the views of the BBC, unless specifically stated.''

delete from EmailTemplates where name=''UserComplaintEmailVerification''
insert into EmailTemplates
select ''Your complaint on the BBC has been submitted.'', @strPrint, ''UserComplaintEmailVerification'', modclassid, 0
from moderationclass

',
N'Add verification email template to database', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Markn: 2818D0FF-F4F1-4C58-8C91-6044FFF407F0',
N'
-- Copy existing data into a temp table
SELECT * 
	INTO dbo.tmp_RiskModDecisionsForThreadEntries
	FROM dbo.RiskModDecisionsForThreadEntries

-- Drop exiting table
DROP TABLE dbo.RiskModDecisionsForThreadEntries

-- Recreate table, so that IsRisky can contain NULLs
CREATE TABLE dbo.RiskModDecisionsForThreadEntries
(
	DateAssessed datetime NOT NULL,
	SiteId int NOT NULL,
	ForumId int NOT NULL,
	ThreadEntryId int NOT NULL,
	IsRisky bit NULL
)  ON [PRIMARY]

ALTER TABLE dbo.RiskModDecisionsForThreadEntries ADD CONSTRAINT
	DF_RiskModDecisionsForThreadEntries_DateAssessed DEFAULT getdate() FOR DateAssessed
	
CREATE UNIQUE CLUSTERED INDEX [CIX_RiskModDecisionsForThreadEntries] ON [dbo].[RiskModDecisionsForThreadEntries] (ThreadEntryId)
	
CREATE INDEX [IX_RiskModDecisionsForThreadEntries_DateAssessed] ON [dbo].[RiskModDecisionsForThreadEntries] (DateAssessed)

-- Copy the data back into the new table
INSERT dbo.RiskModDecisionsForThreadEntries
	SELECT DateAssessed,SiteId,ForumId,ThreadEntryId,IsRisky
		FROM dbo.tmp_RiskModDecisionsForThreadEntries

-- Drop temp table
DROP TABLE dbo.tmp_RiskModDecisionsForThreadEntries
',
N'Recreating table RiskModDecisionsForThreadEntries so that IsRisky can hold NULL values', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'Markn: 4530C7EB-CAA9-4582-9223-FE5F0F59F4F1',
N'
IF dbo.udf_tableexists(''BIEventQueueHandled'') = 0
BEGIN
	CREATE TABLE [dbo].[BIEventQueueHandled](
		[EventID] [int] NOT NULL CONSTRAINT PK_BIEventQueueHandled PRIMARY KEY CLUSTERED,
		[EventType] [int] NOT NULL,
		[ItemID] [int] NOT NULL,
		[ItemType] [int] NOT NULL,
		[ItemID2] [int] NOT NULL,
		[ItemType2] [int] NOT NULL,
		[EventDate] [datetime] NOT NULL,
		[EventUserID] [int] NOT NULL
	) ON [PRIMARY]
END
',
N'Creating table BIEventQueueHandled', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {F784BBB9-851D-46d6-B2A8-40656F8E26FE}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''CommentForum'', ''AllowNotSignedInRating'', ''0'',1, ''Whether users must be logged into rate a comment.'')
',
N'Create AllowNotSignedInRating option for comments', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {F784BBB9-851D-46d6-B2A8-40656F8E26GH}',
N'
ALTER TABLE dbo.ModerationClass ADD
	ItemRetrievalType tinyint NOT NULL CONSTRAINT DF_ModerationClass_ItemRetrievalType DEFAULT 0

',
N'Add column for storing ItemRetrievalType', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {F784BBB9-851D-46d6-B2A8-40656F8E26FF}',
N'
UPDATE dbo.ModerationClass
set ItemRetrievalType=1
where LIFOQueue = 1

ALTER TABLE dbo.ModerationClass
	DROP CONSTRAINT DF_ModerationClass_LIFOQueue
	
ALTER TABLE dbo.ModerationClass
	DROP COLUMN LIFOQueue
',
N'remove lifoqueue column', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9D994E40-898B-4b4c-BD79-45ABC8BC95E1}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''Moderation'', ''MaxItemsInPriorityModeration'', ''0'',0, ''The maximum number of moderated items before forum removed from priority moderation - 0 means never.'')
',
N'Create MaxItemsInPriorityModeration site option', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9D994E40-898B-4b4c-BD79-45ABC8BC96F1}',
N'
	delete from SiteActivityTypes where activitytype=16

	insert into SiteActivityTypes values (16,''User Standard'')

',
N'Add user back into standard type', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9D994E40-908B-4b4c-BD79-45ABC8BC96F1}',
N'
	delete from SiteActivityTypes where activitytype=17
	delete from SiteActivityTypes where activitytype=18
	delete from SiteActivityTypes where activitytype=19

	insert into SiteActivityTypes values (17,''User Post'')
	insert into SiteActivityTypes values (18,''ComplaintUpHeld'')
	insert into SiteActivityTypes values (19,''ComplaintRejected'')

',
N'Add new site event types', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {8F994E40-898B-454c-EF12-45ABC8BC96F2}7',
N'

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserReputationScore_ModerationClass'') AND parent_object_id = OBJECT_ID(N''dbo.UserReputationScore''))
BEGIN
ALTER TABLE dbo.UserReputationScore DROP CONSTRAINT FK_UserReputationScore_ModerationClass
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserReputationScore_Users'') AND parent_object_id = OBJECT_ID(N''dbo.UserReputationScore''))
BEGIN
ALTER TABLE dbo.UserReputationScore DROP CONSTRAINT FK_UserReputationScore_Users
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.UserReputationScore'') AND type in (N''U''))
BEGIN
DROP TABLE dbo.UserReputationScore
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserPostEvents_ModerationClass'') AND parent_object_id = OBJECT_ID(N''dbo.UserPostEvents''))
BEGIN
ALTER TABLE dbo.UserPostEvents DROP CONSTRAINT FK_UserPostEvents_ModerationClass
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserPostEvents_SiteActivityTypes'') AND parent_object_id = OBJECT_ID(N''dbo.UserPostEvents''))
BEGIN
ALTER TABLE dbo.UserPostEvents DROP CONSTRAINT FK_UserPostEvents_SiteActivityTypes
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserPostEvents_Sites'') AND parent_object_id = OBJECT_ID(N''dbo.UserPostEvents''))
BEGIN
ALTER TABLE dbo.UserPostEvents DROP CONSTRAINT FK_UserPostEvents_Sites
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserPostEvents_ThreadEntries'') AND parent_object_id = OBJECT_ID(N''dbo.UserPostEvents''))
BEGIN
ALTER TABLE dbo.UserPostEvents DROP CONSTRAINT FK_UserPostEvents_ThreadEntries
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserPostEvents_Users'') AND parent_object_id = OBJECT_ID(N''dbo.UserPostEvents''))
BEGIN
ALTER TABLE dbo.UserPostEvents DROP CONSTRAINT FK_UserPostEvents_Users
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.UserPostEvents'') AND type in (N''U''))
BEGIN
DROP TABLE dbo.UserPostEvents
END
',
N'Add new site event types', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {8F994E40-898B-454c-EF12-45ABC8BC96F3}7',
N'


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserEventScore_ModerationClass'') AND parent_object_id = OBJECT_ID(N''dbo.UserEventScore''))
BEGIN
ALTER TABLE dbo.UserEventScore DROP CONSTRAINT FK_UserEventScore_ModerationClass
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserEventScore_SiteActivityTypes'') AND parent_object_id = OBJECT_ID(N''dbo.UserEventScore''))
BEGIN
ALTER TABLE dbo.UserEventScore DROP CONSTRAINT FK_UserEventScore_SiteActivityTypes
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''DF_UserEventScore_score'') AND type = ''D'')
BEGIN
ALTER TABLE dbo.UserEventScore DROP CONSTRAINT DF_UserEventScore_score
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.UserEventScore'') AND type in (N''U''))
BEGIN
DROP TABLE dbo.UserEventScore
END


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserSiteEvents_ModerationClass'') AND parent_object_id = OBJECT_ID(N''dbo.UserSiteEvents''))
BEGIN
ALTER TABLE dbo.UserSiteEvents DROP CONSTRAINT FK_UserSiteEvents_ModerationClass
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserSiteEvents_SiteActivityItems'') AND parent_object_id = OBJECT_ID(N''dbo.UserSiteEvents''))
BEGIN
ALTER TABLE dbo.UserSiteEvents DROP CONSTRAINT FK_UserSiteEvents_SiteActivityItems
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserSiteEvents_SiteActivityTypes'') AND parent_object_id = OBJECT_ID(N''dbo.UserSiteEvents''))
BEGIN
ALTER TABLE dbo.UserSiteEvents DROP CONSTRAINT FK_UserSiteEvents_SiteActivityTypes
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserSiteEvents_Sites'') AND parent_object_id = OBJECT_ID(N''dbo.UserSiteEvents''))
BEGIN
ALTER TABLE dbo.UserSiteEvents DROP CONSTRAINT FK_UserSiteEvents_Sites
END

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''dbo.FK_UserSiteEvents_Users'') AND parent_object_id = OBJECT_ID(N''dbo.UserSiteEvents''))
BEGIN
ALTER TABLE dbo.UserSiteEvents DROP CONSTRAINT FK_UserSiteEvents_Users
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.UserSiteEvents'') AND type in (N''U''))
BEGIN
DROP TABLE dbo.UserSiteEvents
END
',
N'Add User Reputation tables2', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {8F994E40-908B-454c-EG12-45ACC8BC96F1}7',
N'

CREATE TABLE dbo.UserSiteEvents(
	typeid int NOT NULL,
	eventdate datetime NOT NULL,
	siteid int NOT NULL,
	modclassid int NOT NULL,
	siteeventid int NOT NULL,
	score smallint NOT NULL,
	accumulativescore smallint NOT NULL,
	userid int NOT NULL
)

CREATE TABLE dbo.UserPostEvents(
	typeid int NOT NULL,
	eventdate datetime NOT NULL,
	--siteid int NOT NULL,
	modclassid int NOT NULL,
	score smallint NOT NULL,
	accumulativescore smallint NOT NULL,
	userid int NOT NULL,
	numberofposts int
)

CREATE TABLE dbo.UserEventScore(
	modclassid int NOT NULL,
	typeid int NOT NULL,
	score smallint NOT NULL
)

ALTER TABLE dbo.UserEventScore ADD  CONSTRAINT DF_UserEventScore_score  DEFAULT ((0)) FOR score

CREATE TABLE dbo.UserReputationScore(
	userid int NOT NULL,
	modclassid int NOT NULL,
	accumulativescore smallint NOT NULL
)

',
N'Add User Reputation tables3', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {8F994E40-908B-454c-EF12-45ABC8BC96F2}7',
N'

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	FK_UserSiteEvents_SiteActivityTypes FOREIGN KEY
	(
	typeid
	) REFERENCES dbo.SiteActivityTypes
	(
	activitytype
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	FK_UserSiteEvents_Sites FOREIGN KEY
	(
	siteid
	) REFERENCES dbo.Sites
	(
	SiteID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	FK_UserSiteEvents_ModerationClass FOREIGN KEY
	(
	modclassid
	) REFERENCES dbo.ModerationClass
	(
	ModClassID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	FK_UserSiteEvents_Users FOREIGN KEY
	(
	userid
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	FK_UserSiteEvents_SiteActivityItems FOREIGN KEY
	(
	siteeventid
	) REFERENCES dbo.SiteActivityItems
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserPostEvents ADD CONSTRAINT
	FK_UserPostEvents_SiteActivityTypes FOREIGN KEY
	(
	typeid
	) REFERENCES dbo.SiteActivityTypes
	(
	activitytype
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserPostEvents ADD CONSTRAINT
	FK_UserPostEvents_Users FOREIGN KEY
	(
	userid
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
--ALTER TABLE dbo.UserPostEvents ADD CONSTRAINT
	--FK_UserPostEvents_Sites FOREIGN KEY
	--(
	--siteid
	--) REFERENCES dbo.Sites
	--(
	--SiteID
	--) ON UPDATE  NO ACTION 
	 --ON DELETE  NO ACTION 

ALTER TABLE dbo.UserPostEvents ADD CONSTRAINT
	FK_UserPostEvents_ModerationClass FOREIGN KEY
	(
	modclassid
	) REFERENCES dbo.ModerationClass
	(
	ModClassID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 


ALTER TABLE dbo.UserEventScore ADD CONSTRAINT
	FK_UserEventScore_ModerationClass FOREIGN KEY
	(
	modclassid
	) REFERENCES dbo.ModerationClass
	(
	ModClassID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserEventScore ADD CONSTRAINT
	FK_UserEventScore_SiteActivityTypes FOREIGN KEY
	(
	typeid
	) REFERENCES dbo.SiteActivityTypes
	(
	activitytype
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserReputationScore ADD CONSTRAINT
	FK_UserReputationScore_Users FOREIGN KEY
	(
	userid
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 

ALTER TABLE dbo.UserReputationScore ADD CONSTRAINT
	FK_UserReputationScore_ModerationClass FOREIGN KEY
	(
	modclassid
	) REFERENCES dbo.ModerationClass
	(
	ModClassID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	 
ALTER TABLE dbo.UserPostEvents ADD CONSTRAINT
	PK_UserPostEvents PRIMARY KEY CLUSTERED 
	(
	eventdate,
	modclassid,
	userid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE dbo.UserSiteEvents ADD CONSTRAINT
	PK_UserSiteEvents PRIMARY KEY CLUSTERED 
	(
	siteeventid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

',
N'Add User Reputation tables 4', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9D994E40-898B-4b4c-BD79-45ABDE8BC95E1}',
N'

delete from siteoptions where name=''CustomHouseRuleURL''

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''Moderation'', ''CustomHouseRuleURL'', '''',2, ''Url to custom url for house rules within comments, empty means default.'')

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
select siteid, ''Moderation'', ''CustomHouseRuleURL'', ''http://www.bbc.co.uk/cbbc/mb/rules.shtml'',2, ''Url to custom url for house rules within comments, empty means default.''
from sites where urlname=''mbnewsround''
',
N'Create CustomHouseRuleURL site option', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9D994F50-898B-4b4c-BD79-45ABDE8BC95E1}',
N'

delete from siteoptions where name=''AllowNegativeRatings''

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''CommentForum'', ''AllowNegativeRatings'', ''1'',1, ''Display negative rating element.'')

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
select siteid, ''CommentForum'', ''AllowNegativeRatings'', ''0'',1, ''Display negative rating element.''
from sites where urlname=''mbnewsround''
',
N'Create AllowNegativeRatings site option', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {9D994F50-898B-4b4c-BD88-45ABDE8BC95E1}',
N'

insert into dbo.UserEventScore
select m.modclassid, s.activitytype,0
from  ModerationClass m, siteactivitytypes s

',
N'Initiate user event scores to 0', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {FE994F50-898B-4b4c-BD88-45ABDE8BC95E1}1',
N'
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[BannedIPAddress]'') AND type in (N''U''))
DROP TABLE [dbo].[BannedIPAddress]

CREATE TABLE [dbo].[BannedIPAddress](
	[UserId] [int] NOT NULL,
	[IPAddress] [varchar](25) NULL,
	[BBCUID] [uniqueidentifier] NULL
) ON [PRIMARY]


',
N'Create banned ip address table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {FGH994F50-898B-4b4c-BD88-45ABDE8BC95E1}2',
N'
update users
set email=''dnateam@bbc.co.uk'',
username=''DNA System'',
loginname=''DNA System'',
password='''',
status=0
where userid=5

delete from preferences where userid=5
',
N'Edit/create system user', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9CA018B2-C204-4cf1-A9A7-76FB463C80E7}1',
N'
CREATE TABLE [dbo].[UserReputationThreshold](
	[modclassid] [int] NOT NULL,
	[maxscore] [smallint] NOT NULL,
	[trustedscore] [smallint] NOT NULL,
	[normalscore] [smallint] NOT NULL,
	[postmodscore] [smallint] NOT NULL,
	[premodscore] [smallint] NOT NULL,
	[bannedscore] [smallint] NOT NULL
) ON [PRIMARY]


ALTER TABLE [dbo].[UserReputationThreshold]  WITH CHECK ADD  CONSTRAINT [FK_UserReputationThreshold_ModerationClass] FOREIGN KEY([modclassid])
REFERENCES [dbo].[ModerationClass] ([ModClassID])

ALTER TABLE [dbo].[UserReputationThreshold] CHECK CONSTRAINT [FK_UserReputationThreshold_ModerationClass]

insert into dbo.userreputationthreshold
select modclassid, 11, 5,0,0,-5,-10
from moderationclass

',
N'Add threshold table and fill with defaults', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9CA018B2-C204-4Df1-A9A7-76FB463C80E7}1',
N'
truncate table dbo.UserReputationScore

ALTER TABLE dbo.UserReputationScore ADD CONSTRAINT
	PK_UserReputationScore PRIMARY KEY CLUSTERED 
	(
	userid,
	modclassid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



',
N'Add constraint to table for one entry per user/modclass', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: {9CA018B2-C204-4Df1-A9A7-76FB463C80E8}1',
N'
truncate table dbo.UserReputationScore

ALTER TABLE dbo.UserReputationScore ADD
	lastupdated datetime NOT NULL CONSTRAINT DF_UserReputationScore_lastupdated DEFAULT getdate()

',
N'Add last updated to dbo.UserReputationScore', @curerror OUTPUT
IF (@curerror <> 0) RETURN

-- Email Encryption...

IF (@curerror <> 0) RETURN
EXEC dbu_dosql N'MarkN: BAB755E1-6637-404F-9178-D82076CE5C49',
N'
IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = ''key_EmailAddress'')
BEGIN
	RAISERROR (''Run script "Main\Source\Databases\The Guide\DBScripts\Keys For Email Encryption On Dev.sql" to create the email encryption key'',16,1);
END
',
N'Checking email encryption key has been created', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: BAB755E1-6637-404F-9178-D82076CE5C46' ,
N'
IF dbo.udf_columnexists(''dbo.Users'',''EncryptedEmail'') = 0
BEGIN
	ALTER TABLE dbo.Users ADD EncryptedEmail varbinary(8000) NULL
	ALTER TABLE dbo.Users ADD HashedEmail varbinary(900) NULL
	CREATE NONCLUSTERED INDEX IX_Users_HashedEmail ON dbo.Users (HashedEmail) 
END
',
N'In Users table,create EncryptedEmail and HashedEmail columns, and index on HashedEmail', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: BAB755E1-6637-404F-9178-D82076CE5C47',
N'
IF dbo.udf_columnexists(''dbo.BannedEmails'',''EncryptedEmail'') = 0
BEGIN
	ALTER TABLE dbo.BannedEmails ADD EncryptedEmail varbinary(8000) NULL
	ALTER TABLE dbo.BannedEmails ADD HashedEmail varbinary(900) NULL
	CREATE NONCLUSTERED INDEX IX_BannedEmails_HashedEmail ON dbo.BannedEmails(HashedEmail)
END
',
N'In BannedEmails table, create EncryptedEmail and HashedEmail columns, and index on HashedEmail', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: BCB755E1-6637-404F-9178-D82076CE5C47, 1',
N'
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserReputationThreshold_ModClassid] ON [dbo].[UserReputationThreshold] 
(
	[modclassid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

',
N'Add index for threshold table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: BFGB755E1-6637-404F-9178-D82076CE5C47, 1',
N'
insert into UserStatuses (userstatusid, userstatusdescription) values (5, ''Deactivated'')
insert into UserStatuses (userstatusid, userstatusdescription) values (6, ''Trusted'')
',
N'Adding new statuses to table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: BFGB755F2-6637-404F-9178-D82076CE5C47, 1',
N'
insert into SiteActivityTypes (activitytype, description) values (20, ''UserModeratedTrusted'')

',
N'Adding new SiteActivityTypes', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: {49A1986E-E101-4ef3-A8AD-DE1A8BA03F06}', 
	N'

	EXEC createnewuserfromssoid @ssouserid=1166868344, @username = ''test_trusted'', @email=''dnacomments+test_trusted@gmail.com '', @siteid=1, @firstnames=''test_trusted'', @lastname =''test_trusted''
	
	declare @userid int
	select @userid = DnaUserID
	from signinuseridmapping
	where SSOUserID = 1166868344
	
	update preferences
	set prefstatus=6
	where userid = @userid
	',
	N'Creating new test user which is trusted', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END



EXEC dbu_dosql N'MarkN: D30AF98B-0530-42F0-9D01-15AB723E2490',
N'
IF dbo.udf_columnexists(''dbo.BannedEmails'',''Email'') = 1
BEGIN
	-- Populate EncryptedEmail and HashedEmail while we still have an Email column
	EXEC openemailaddresskey
	UPDATE dbo.BannedEmails
		SET EncryptedEmail = dbo.udf_encryptemailaddress(Email,0),
			HashedEmail = dbo.udf_hashemailaddress(Email);

	-- Remove the Email column
	ALTER TABLE dbo.BannedEmails DROP CONSTRAINT PK_BannedEmails
	ALTER TABLE dbo.BannedEmails DROP COLUMN Email

	-- Make IX_BannedEmails_HashedEmail unique
	DROP INDEX IX_BannedEmails_HashedEmail ON dbo.BannedEmails
	CREATE UNIQUE NONCLUSTERED INDEX IX_BannedEmails_HashedEmail ON dbo.BannedEmails(HashedEmail)
END
',
N'Populating EncryptedEmail and HashedEmail, deleting Email column, and making IX_BannedEmails_HashedEmail unique', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: D30AF98B-0530-42F0-9D01-15AB723E2491',
N'
EXEC openemailaddresskey

UPDATE users
	SET EncryptedEmail = dbo.udf_encryptemailaddress(email,userid)
	WHERE email <> '''' AND email <> ''0'' AND email IS NOT NULL AND encryptedemail IS NULL
	
DROP INDEX IX_Users_email ON dbo.Users
ALTER TABLE dbo.Users DROP COLUMN Email
',
N'Ensure all emails have been encrypted, then drop the Email column - EEK!', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MAP: DFFGB755F2-6637-404F-9178-D82076CE5C47, 1',
N'
insert into UserEventScore
select modclassid, 20, 0
from moderationclass


',
N'Adding new SiteActivity score', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: DFFGB755F2-6637-404F-9180-D82076CE5C47, 1',
N'
insert into SiteActivityTypes (activitytype, description) values (21, ''ModeratePostFailedReversal'')

insert into UserEventScore
select modclassid, 21, 5
from moderationclass

',
N'Adding new fail reversal', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: DFFFG755F2-6637-444F-9180-D82076CE5C47, 3',
N'

IF dbo.udf_columnexists(''dbo.UserEventScore'',''overridescore'') = 1
BEGIN
	ALTER TABLE dbo.UserEventScore
		DROP CONSTRAINT DF_UserEventScore_overridescore

	ALTER TABLE dbo.UserEventScore
		DROP COLUMN overridescore
END
	
ALTER TABLE dbo.UserEventScore ADD
	overridescore bit NOT NULL CONSTRAINT DF_UserEventScore_overridescore DEFAULT 0

',
N'Adding override values', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: DFFFG755F2-6677-404F-9180-D82076CE5C47, 2',
N'

update dbo.usereventscore set score = -7, overridescore=1 where typeid=10 --premod
update dbo.usereventscore set score = -2, overridescore=1 where typeid=11 --postmod
update dbo.usereventscore set score = -11, overridescore=1 where typeid=12 --banned
update dbo.usereventscore set score = -11, overridescore=1 where typeid=13 --deactiviated
update dbo.usereventscore set score = 0, overridescore=1 where typeid=16 --standard
update dbo.usereventscore set score = 7, overridescore=1 where typeid=20 --trusted

',
N'change override values', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: DFFFG755F2-6677-404F-9180-D35076CE5C47,0',
N'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''ModTermMapping'') AND TYPE IN (N''U''))
BEGIN
	DROP TABLE [dbo].[ModTermMapping]
END

		
CREATE TABLE [dbo].[ModTermMapping](
	[ModID] [int] NOT NULL,
	[TermID] [int] NOT NULL
) ON [PRIMARY]

',
N'creates a modtermmapping table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: DFFFG755F2-6677-404F-9180-D35076CE5C45,0',
N'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''ModTermMapping'') AND TYPE IN (N''U''))
BEGIN
	DROP TABLE [dbo].[ModTermMapping]
END

		
CREATE TABLE [dbo].[ModTermMapping](
	[ModID] [int] NOT NULL,
	[TermID] [int] NOT NULL
) ON [PRIMARY]

CREATE UNIQUE CLUSTERED INDEX cidx_ModTermMapping ON [dbo].[ModTermMapping] ([ModID],[TermID])

',
N'creates a modtermmapping table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: DFFFG755F2-6677-404F-9180-D45076CE5C45,0',
N'

--Check and delete the temporary table if exists
IF OBJECT_ID(''tempdb..#TEMPTERMSTABLE'') IS NOT NULL
BEGIN
	DROP TABLE #TEMPTERMSTABLE
END

CREATE TABLE #TEMPTERMSTABLE(
	ID			INT IDENTITY(1,1) NOT NULL,
	ModClassId	INT NOT NULL,
	TermId		INT NOT NULL,
	ActionId	INT NOT NULL,
	Processed	BIT NOT NULL 
)

INSERT INTO #TEMPTERMSTABLE
	select modclassid, termid, actionid, 0 from TermsByModClass
	EXCEPT
	select modclassid, termid, actionid, 0 from TermsByModClassHistory

DECLARE @Id			INT
DECLARE @modclassId	INT
DECLARE @termId		INT
DECLARE @actionId	INT
DECLARE @updateHistoryId INT

--If reason unknown already exists
IF EXISTS (SELECT * FROM TermsUpdateHistory WHERE UserId = 6 AND notes LIKE ''Reason Unknown'')
BEGIN
	SELECT Top 1 @updateHistoryId = MAX(id) FROM TermsUpdateHistory WHERE UserId = 6 AND notes LIKE ''Reason Unknown''
END
ELSE -- insert the data and retrieve the identity
BEGIN
	INSERT INTO TermsUpdateHistory(userid, notes)
	VALUES(6, ''Reason Unknown'')

	SELECT @updateHistoryId = @@identity 
END

-- Loop through each row in the temporary table
WHILE (SELECT COUNT(*) FROM #TEMPTERMSTABLE WHERE Processed = 0) > 0
BEGIN

	SELECT TOP 1 @Id = ID, 
				 @modclassId = ModClassId,
				 @termId	= TermId,
				 @actionId	= ActionId 
	FROM #TEMPTERMSTABLE WHERE Processed = 0

	-- Insert the data into the TermsByModClassHistory
	INSERT INTO TermsByModClassHistory(termid, modclassid, actionid, updateid)
	VALUES (@termId, @modclassId, @actionId, @updateHistoryId )

	-- Set Processed to 1
	UPDATE #TEMPTERMSTABLE SET Processed = 1 WHERE ID = @Id

END

DROP TABLE #TEMPTERMSTABLE

-- Deleting the duplicate rows, Not required but added for more safety
;WITH CTE AS
(
	SELECT ROW_NUMBER() OVER (PARTITION BY termid, modclassid, actionid, updateid ORDER BY modclassid) AS rownumber, *
	FROM TermsByModClassHistory
)
DELETE FROM CTE WHERE rownumber > 1

',
N'creates modclasshistory data for the missing terms mod class mapping', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: DFHJUB755F2-6637-404F-9180-D82076CE5C47, 1',
N'
delete from SiteOptions where name=''UseIDV4''

INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''CommentForum'', ''UseIDV4'', ''0'',1, ''Whether to user ID V4 in UI'')


',
N'add UseIDV4 siteoption', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MarcusP: 4B9200F4-CADC-78ER-B608-BD19C80E3AF0',
N'
DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''Threadmod'',''ComplaintText'')
IF @type IS NULL RAISERROR (''Failed to find type for column'',20,1) WITH LOG

IF @type <> ''nvarchar''
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR (''The complaint text row in Threadmod has not been converted to nvarchar.  Please run the script Convert ComplaintText and insert to Unicode.sql'',20,1) WITH LOG
END
',
N'Checking that Complaint Text has been converted to Unicode', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarcusP: 4B9200F4-CADC-78ER-B608-BD19C80E3457',
N'
IF NOT EXISTS ( SELECT * FROM SiteOptions WHERE SiteID = 0 AND Section = ''General'' AND Name = ''ComplaintUrl'')
BEGIN
	INSERT INTO dbo.SiteOptions SELECT Section = ''General'', SiteID = 0, Name = ''ComplaintUrl'', Value = ''http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1'', Type = 2, Description = ''Custom url for complaint process of that site - uses replacements''
END
	
',
N'Create siteoption for complaint location', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: DGIJUB755F2-6637-404F-9180-D82076CE5C47,2',
N'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''ForumModTermMapping'') AND TYPE IN (N''U''))
BEGIN
	DROP TABLE [dbo].[ForumModTermMapping]
END

CREATE TABLE [dbo].[ForumModTermMapping](
	[ThreadModID] [int] NOT NULL,
	[ModClassID] [int] NOT NULL DEFAULT 0,
	[ForumID] [int] NOT NULL DEFAULT 0,
	[TermID] [int] NOT NULL
) ON [PRIMARY]

CREATE CLUSTERED INDEX IX_ForumModTermMapping_ThreadModID ON [dbo].[ForumModTermMapping] ([ThreadModID])

',
N'add UseIDV4 siteoption', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'SRI: DGIJUB755F2-6637-404F-9180-D82076CE5C58,3',
N'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''TermsByForum'') AND TYPE IN (N''U''))
BEGIN
	DROP TABLE [dbo].[TermsByForum]
END

CREATE TABLE [dbo].[TermsByForum](
	[termid] [int] NOT NULL,
	[forumid] [int] NOT NULL,
	[actionid] [tinyint] NOT NULL CONSTRAINT [DF_TermsByForum_action]  DEFAULT ((0))
) ON [PRIMARY]

ALTER TABLE [dbo].[TermsByForum]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForum_Forums] FOREIGN KEY([forumid])
REFERENCES [dbo].[Forums] ([ForumID])

ALTER TABLE [dbo].[TermsByForum] CHECK CONSTRAINT [FK_TermsByForum_Forums]

ALTER TABLE [dbo].[TermsByForum]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForum_TermsActionLookup] FOREIGN KEY([actionid])
REFERENCES [dbo].[TermsActionLookup] ([id])

ALTER TABLE [dbo].[TermsByForum] CHECK CONSTRAINT [FK_TermsByForum_TermsActionLookup]

ALTER TABLE [dbo].[TermsByForum]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForum_TermsLookup] FOREIGN KEY([termid])
REFERENCES [dbo].[TermsLookup] ([id])

ALTER TABLE [dbo].[TermsByForum] CHECK CONSTRAINT [FK_TermsByForum_TermsLookup]

CREATE CLUSTERED INDEX IX_TermsByForum_forumid ON [dbo].[TermsByForum] ([forumid])

',
N'add UseIDV4 siteoption', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'SRI: DGIJUB755F2-6637-404F-9180-E12076CE5C47, 3',
N'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''TermsByForumHistory'') AND TYPE IN (N''U''))
BEGIN
	DROP TABLE [dbo].[TermsByForumHistory]
END

CREATE TABLE [dbo].[TermsByForumHistory](
	[termid] [int] NOT NULL,
	[forumid] [int] NOT NULL,
	[actionid] [tinyint] NOT NULL,
	[updateid] [int] NOT NULL
) ON [PRIMARY]


ALTER TABLE [dbo].[TermsByForumHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForumHistory_Forums] FOREIGN KEY([forumid])
REFERENCES [dbo].[Forums] ([ForumID])

ALTER TABLE [dbo].[TermsByForumHistory] CHECK CONSTRAINT [FK_TermsByForumHistory_Forums]

ALTER TABLE [dbo].[TermsByForumHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForumHistory_TermsActionLookup] FOREIGN KEY([actionid])
REFERENCES [dbo].[TermsActionLookup] ([id])

ALTER TABLE [dbo].[TermsByForumHistory] CHECK CONSTRAINT [FK_TermsByForumHistory_TermsActionLookup]

ALTER TABLE [dbo].[TermsByForumHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForumHistory_TermsLookup] FOREIGN KEY([termid])
REFERENCES [dbo].[TermsLookup] ([id])

ALTER TABLE [dbo].[TermsByForumHistory] CHECK CONSTRAINT [FK_TermsByForumHistory_TermsLookup]

ALTER TABLE [dbo].[TermsByForumHistory]  WITH CHECK ADD  CONSTRAINT [FK_TermsByForumHistory_TermsUpdateHistory] FOREIGN KEY([updateid])
REFERENCES [dbo].[TermsUpdateHistory] ([id])

ALTER TABLE [dbo].[TermsByForumHistory] CHECK CONSTRAINT [FK_TermsByForumHistory_TermsUpdateHistory]

CREATE CLUSTERED INDEX IX_TermsByForumHistory_forumid ON [dbo].[TermsByForumHistory] ([forumid])

',
N'add UseIDV4 siteoption', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: 3A9AC1D4-C54D-42B1-ABB8-778988D4EF88, 7',
N'
INSERT INTO EmailTemplates([Subject], [Body], [Name], [ModClassID], [AutoFormat])
	SELECT ''Terms section updated for the forum, ++**forum_title**++.'',''Hi, ++**new_line**++ ++**new_line**++The Terms section of the forum, ++**forum_title**++ (++**forum_url**++) has been updated with the following details, ++**new_line**++  ++**term_details**++. ++**new_line**++ ++**new_line**++To add these to the full terms list, please go to ++**terms_filter**++ ++**new_line**++ ++**new_line**++Regards, ++**new_line**++ ++**new_line**++Social Publishing Team'',''TermsAddedToCommentForumEmail'', ModClassID, 0
	FROM moderationclass
',
N'insert data for new email template ', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: 4B9AC1D4-C54D-42B1-ABB8-778988D4EF88, 1',
N'

IF NOT EXISTS(SELECT * FROM sys.columns where Name = N''TwitterUserID'' AND Object_ID = Object_ID(N''dbo.SignInUserIDMapping''))
BEGIN

	ALTER TABLE dbo.SignInUserIDMapping ADD TwitterUserID NVARCHAR(40) DEFAULT NULL	

END
',
N'add the additional column for Twitter User', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn:495F6B61-49EF-4F43-987A-70130363A260',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''Moderation'', ''ExternalCommentQueuedExpiryTime'', ''-1'',0, ''The time (in minutes) an external comment (e.g. tweet) will stay in the moderation queue before automatically being removed'')
',
N'New site option for specifying "external" comment queued expiry time', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn:495F6B61-49EF-4F43-987A-70130363A261',
N'
	ALTER TABLE dbo.PreModPostings ADD ApplyExpiryTime bit DEFAULT(0) NOT NULL
',
N'Added flag to PreModPostings table to state that it should have the configured expiry time applied to it', @curerror OUTPUT
IF (@curerror <> 0) RETURN
	
EXEC dbu_dosql N'Markn:495F6B61-49EF-4F43-987A-70130363A262-v2',
N'
IF dbo.udf_tableexists(''ThreadModExpired'') = 1
	DROP TABLE [dbo].[ThreadModExpired]

CREATE TABLE [dbo].[ThreadModExpired]
(
	[ModID] [int] CONSTRAINT PK_ThreadModExpired PRIMARY KEY CLUSTERED,
	[ForumID] [int] NULL,
	[ThreadID] [int] NULL,
	[PostID] [int] NULL,
	[DateQueued] [datetime] NULL,
	[DateLocked] [datetime] NULL,
	[LockedBy] [int] NULL,
	[NewPost] [tinyint] NULL,
	[Status] [int] NULL,
	[Notes] [varchar](max) NULL,
	[DateReferred] [datetime] NULL,
	[DateCompleted] [datetime] NULL,
	[ReferredBy] [int] NULL,
	[ComplainantID] [int] NULL,
	[CorrespondenceEmail] [varchar](255) NULL,
	[SiteID] [int] NULL,
	[IsPreModPosting] [tinyint] NULL,
	[ComplaintText] [nvarchar](max) NULL,
	[EncryptedCorrespondenceEmail] varbinary(8000) NULL
)
',
N'Create ThreadModExpired table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markn:495F6B61-49EF-4F43-987A-70130363A263',
N'
CREATE TABLE [dbo].[PreModPostingsExpired]
(
	[ModID] [int] NOT NULL CONSTRAINT PK_PreModPostingsExpired PRIMARY KEY CLUSTERED,
	[UserID] [int] NOT NULL,
	[ForumID] [int] NOT NULL,
	[ThreadID] [int] NULL,
	[InReplyTo] [int] NULL,
	[Subject] [nvarchar](255) NULL,
	[Body] [nvarchar](max) NULL,
	[PostStyle] [int] NOT NULL,
	[Hash] [uniqueidentifier] NOT NULL,
	[Keywords] [varchar](255) NULL,
	[Nickname] [nvarchar](255) NULL,
	[Type] [int] NULL,
	[EventDate] [datetime] NULL,
	[ClubID] [int] NULL,
	[NodeID] [int] NULL,
	[IPAddress] [varchar](25) NULL,
	[DatePosted] [datetime] NULL,
	[ThreadRead] [tinyint] NOT NULL,
	[ThreadWrite] [tinyint] NOT NULL,
	[SiteID] [int] NOT NULL,
	[AllowEventEntries] [tinyint] NOT NULL,
	[BBCUID] [uniqueidentifier] NULL,
	[IsComment] [tinyint] NULL,
	[RiskModThreadEntryQueueId] [int] NULL,
	[ApplyExpiryTime] [bit] NOT NULL
)
',
N'Create PreModPostingsExpired table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MAP: {49A1986E-E101-4ef3-A8AD-DE1A8BA03F16}', 
	N'

	delete from Preferences WHERE UserID = 1090501859 AND SiteID = 66 
	',
	N'fix normal user in smallguide', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MAP: {49A1986E-E101-4ef3-A8AD-DFGA8BA03F16}', 
N'
ALTER TABLE dbo.Sites ADD
	SampleUrl varchar(255) NULL
	
CREATE TABLE dbo.SiteUpdate
	(
	updateid int NOT NULL IDENTITY (1, 1),
	userid int NOT NULL,
	siteid int NOT NULL,
	notes nvarchar(MAX) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]

ALTER TABLE dbo.SiteUpdate ADD CONSTRAINT
	PK_SiteUpdate PRIMARY KEY CLUSTERED 
	(
	updateid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

',
N'add sample url to site table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {49A1986E-E202-4ef3-A8AD-DE1A8BA03F16}', 
N'

insert into bbcdivision (bbcdivisionname) values (''Corporate'')
',
N'Add corporate to divisions', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: E09AF1FA-9C09-44A9-B6BE-8AD848DF44B0' ,
N'
IF dbo.udf_columnexists(''dbo.ThreadMod'',''EncryptedCorrespondenceEmail'') = 0
BEGIN
	ALTER TABLE dbo.ThreadMod ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
END
',
N'In dbo.ThreadMod table,create EncryptedCorrespondenceEmail column', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: E09AF1FA-9C09-44A9-B6BE-8AD848DF44B1' ,
N'
IF dbo.udf_columnexists(''dbo.ArticleMod'',''EncryptedCorrespondenceEmail'') = 0
BEGIN
	ALTER TABLE dbo.ArticleMod ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
END

IF dbo.udf_columnexists(''dbo.GeneralMod'',''EncryptedCorrespondenceEmail'') = 0
BEGIN
	ALTER TABLE dbo.GeneralMod  ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
END

IF dbo.udf_columnexists(''dbo.ThreadModAwaitingEmailVerification'',''EncryptedCorrespondenceEmail'') = 0
BEGIN
	ALTER TABLE dbo.ThreadModAwaitingEmailVerification ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
END
',
N'Create remaining EncryptedCorrespondenceEmail columns', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: DFFFG755F2-6677-404F-9180-D82076CE5FE7, 1',
N'

update UserReputationThreshold
set 
bannedscore=-12,
maxscore=12

update dbo.usereventscore set score = -13, overridescore=1 where typeid=12 --banned
update dbo.usereventscore set score = -13, overridescore=1 where typeid=13 --deactiviated

',
N'change override values', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MAP: {59dA1986E-E202-4ef3-A8AD-DE1A8BA03F16}', 
N'

update bbcdivision set bbcdivisionname = ''FM'' where bbcdivisionname = ''FM&T''
',
N'Changing FM&T to FM in division list', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 26109C85-E115-4D98-96F0-5061B9CFC190' ,
N'
CREATE TABLE ThreadEntriesTweetInfo
(
	ThreadEntryId int NOT NULL CONSTRAINT PK_ThreadEntriesTweetInfo PRIMARY KEY CLUSTERED,
	TweetId bigint NOT NULL
)

CREATE NONCLUSTERED INDEX IX_ThreadEntriesTweetInfo_TweetId ON ThreadEntriesTweetInfo(TweetId)
',
N'Table for capturing tweet info associated with thread entry', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MarkN: 26109C85-E115-4D98-96F0-5061B9CFC191' ,
N'
CREATE TABLE PreModPostingsTweetInfo
(
	ModId int NOT NULL CONSTRAINT PK_PreModPostingsTweetInfo PRIMARY KEY CLUSTERED,
	TweetId bigint NOT NULL
)
',
N'Table for capturing tweet info associated with a premod posting', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 26109C85-E115-4D98-96F0-5061B9CFC192' ,
N'
ALTER TABLE [dbo].[ThreadEntryRating] DROP CONSTRAINT [CK_ThreadEntryRating_nerovalue]
',
N'We need to remove the check constraint from the nero value so we can put in numbers other than 1 and -1', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 736BFD2E-D356-4A6A-932F-ED85C130ABC0-v3' ,
N'
DELETE dbo.PreModPostingsExpired
ALTER TABLE dbo.PreModPostingsExpired ADD Reason char(1) NOT NULL
EXEC sp_rename ''dbo.PreModPostingsExpired'', ''PreModPostingsDeleted''

DELETE dbo.ThreadModExpired
ALTER TABLE dbo.ThreadModExpired ADD Reason char(1) NOT NULL
EXEC sp_rename ''dbo.ThreadModExpired'', ''ThreadModDeleted''
',
N'Rename dbo.PreModPostingsExpired and dbo.ThreadModExpired to "deleted" so they can serve multiple purposes using the new "reason" column', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkN: 736BFD2E-D356-4A6A-932F-ED85C130ABC1-v3' ,
N'
CREATE TABLE dbo.PreModPostingsTweetInfoDeleted
(
	ModId int NOT NULL,
	TweetId bigint NOT NULL,
	Reason char(1) NOT NULL,
	CONSTRAINT PK_PreModPostingsTweetInfoDeleted PRIMARY KEY CLUSTERED (ModId ASC)
)
',
N'New table PreModPostingsTweetInfoDeleted', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Markh: C2F1B39D-3333-34A4-9416-DC64A621111',
N'exec dbu_createsiteoption 0, ''General'', ''MothBallSite'', ''0'' ,1,''Displays a mothball banner when set.''',
N'Creating SiteOption MothBallSite', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 116BFD2E-3333-4A6A-932F-ED85C130CDE',
N'
CREATE TABLE dbo.ThreadEntriesEncrypted
	(
	EntryID int NOT NULL,
	Text nvarchar(MAX) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]

ALTER TABLE dbo.ThreadEntriesEncrypted ADD CONSTRAINT
	PK_ThreadEntriesEncrypted PRIMARY KEY CLUSTERED 
	(
	EntryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

',
N'New table ThreadEntriesEncrypted', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 228BFD2E-AAAA-4A6A-932F-ED85C130111',
N'
CREATE TABLE dbo.ContactForms
	(
	ID int NOT NULL IDENTITY (1, 1),
	ForumID int NOT NULL,
	EncryptedContactEmail nvarchar(512) NOT NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.ContactForms ADD CONSTRAINT
	PK_ContactForms PRIMARY KEY CLUSTERED 
	(
	ForumID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

',
N'New table ContactForms', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: 443BFD2E-EEEE-4A6A-543F-ED85C54321',
N'
ALTER TABLE dbo.CommentForums ADD
	IsContactForm bit NULL

',
N'Adding the ContactForm flag for the comment forum table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: 1212FD23-D346-236A-945F-ED85C130ABBA-v5' ,
N'
IF dbo.udf_columnexists(''dbo.ThreadEntriesTweetInfo'',''OriginalTweetId'') = 0
BEGIN
	ALTER TABLE dbo.ThreadEntriesTweetInfo ADD OriginalTweetId BIGINT NULL
END
ELSE
BEGIN 
	ALTER TABLE dbo.ThreadEntriesTweetInfo ALTER COLUMN OriginalTweetId BIGINT NULL
END

IF dbo.udf_columnexists(''dbo.ThreadEntriesTweetInfo'',''IsOriginalTweetForRetweet'') = 0
BEGIN
	ALTER TABLE dbo.ThreadEntriesTweetInfo ADD IsOriginalTweetForRetweet BIT NOT NULL DEFAULT 0
END

',
N'Added two columns to support the retweet handling', @curerror OUTPUT
IF (@curerror <> 0) RETURN



EXEC dbu_dosql N'SRI: 1212FD23-D345-245A-945F-ED85C130CCCC-v0' ,
N'
IF dbo.udf_columnexists(''dbo.PreModPostingsTweetInfo'',''OriginalTweetId'') = 0
BEGIN
	ALTER TABLE dbo.PreModPostingsTweetInfo ADD OriginalTweetId BIGINT NULL
END


IF dbo.udf_columnexists(''dbo.PreModPostingsTweetInfo'',''IsOriginalTweetForRetweet'') = 0
BEGIN
	ALTER TABLE dbo.PreModPostingsTweetInfo ADD IsOriginalTweetForRetweet BIT NOT NULL DEFAULT 0
END

',
N'Added two columns to support the retweet handling', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'SRI: 1212YZ23-C345-245A-945A-ED85C13011CC-v4' ,
N'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[AtheletesDetails]'') AND TYPE IN (N''U''))
BEGIN
	CREATE TABLE [dbo].[AtheletesDetails](
		ID	INT IDENTITY(1,1) NOT NULL,
		ProfileUID		NVARCHAR(40),
		Name				NVARCHAR(MAX),
		TwitterScreenName	NVARCHAR(40),
		TwitterUserID		NVARCHAR(MAX),
		Processed			BIT NOT NULL DEFAULT 0
	)
END

',
N'Table created for atheletes setup', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI: Ab92YZ23-C345-245A-945A-ED85C13011DD-v3' ,
N'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[AtheletesDetailsSpecial]'') AND TYPE IN (N''U''))
BEGIN
	CREATE TABLE [dbo].[AtheletesDetailsSpecial](
		ID	INT IDENTITY(1,1) NOT NULL,
		ProfileUID			NVARCHAR(MAX),
		Name				NVARCHAR(MAX),
		TwitterScreenName	NVARCHAR(40),
		TwitterUserID		NVARCHAR(MAX),
		[Group]				NVARCHAR(40),
		Processed			BIT NOT NULL DEFAULT 0
	)
END
',
N'Table created for atheletes setup - pundits and ones to watch', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 4444685E-9B5F-42ED-555B-4C519668330F', 
N'
IF dbo.udf_indexexists (''Namespaces'', ''UNQ_SignInUserIDMapping_TwitterUserID_DnaUserID'') = 0
BEGIN
	/****** Object:  Index [UNQ_SignInUserIDMapping_TwitterUserID_DnaUserID]    Script Date: 07/25/2012 09:50:45 ******/
	CREATE UNIQUE NONCLUSTERED INDEX [UNQ_SignInUserIDMapping_TwitterUserID_DnaUserID] ON [dbo].[SignInUserIDMapping] 
	(
		[TwitterUserID] ASC,
		[DnaUserID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
', 
N'Create the unique TwitterUserID DnaUserID index on the SignInUserIDMapping Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 2345433344685E-9B5F-42444ED-555B-4C514449668330F', 
N'
	update siteoptions set description = ''The type of a site: ''''0'''' - Undefined;  ''''1'''' - Blog;  ''''2'''' - Messageboard;  ''''3'''' - Community - h2g2, memoryshare, 606;  ''''4'''' - EmbeddedComments; ''''5'''' - Tweet Modules''
	where name = ''sitetype''
', 
N'Updating the description for the "site type" to state twitter modules site should be 5', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 6669993344685E-AAA-42444ED-555B-4C514449668330F', 
N'
/****** Object:  Index [IX_EMailAlertListMembers_ItemID_ItemType_NotifyType_EMailAlertListID_AlertGroupID]    Script Date: 08/13/2012 14:52:27 ******/
CREATE NONCLUSTERED INDEX [IX_EMailAlertListMembers_ItemID_ItemType_NotifyType_EMailAlertListID_AlertGroupID] ON [dbo].[EMailAlertListMembers] 
(
	[ItemID] ASC,
	[ItemType] ASC,
	[NotifyType] ASC
)
INCLUDE ( [EMailAlertListID],
[AlertGroupID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
', 
N'Creating the missing indexes for the EmailAlertListMembers table part 1', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 111&&&777685E-AAA-42444ED-555B-4C514449668330F', 
N'
/****** Object:  Index [IX_EMailAlertListMembers_NotifyType_EmailAlertListID_ItemID_ItemType_AlertGroupID]    Script Date: 08/13/2012 14:54:59 ******/
CREATE NONCLUSTERED INDEX [IX_EMailAlertListMembers_NotifyType_EmailAlertListID_ItemID_ItemType_AlertGroupID] ON [dbo].[EMailAlertListMembers] 
(
	[NotifyType] ASC
)
INCLUDE ( [EMailAlertListID],
[ItemID],
[ItemType],
[AlertGroupID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
', 
N'Creating the missing indexes for the EmailAlertListMembers table part 2', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: AABBCCDDFFEEGG-AAA-42444ED-555B-4C514449668330F', 
N'
/****** Object:  Index [CIX_EventQueue_EventID_EventType]    Script Date: 08/13/2012 17:45:20 ******/
CREATE CLUSTERED INDEX [CIX_EventQueue_EventID_EventType] ON [dbo].[EventQueue] 
(
	[EventID] ASC,
	[EventType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
', 
N'Creating the missing indexes for the EventQueue Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 1155889966442258-AAA-42444ED-555B-4C514449668330F', 
N'
CREATE NONCLUSTERED INDEX [IX_ThreadMod_LockedBy_NewPost_Status_ComplaintID_ForumID_DateQueued_SiteID]
ON [dbo].[ThreadMod] ([LockedBy],[NewPost],[Status],[ComplainantID])
INCLUDE ([ForumID],[DateQueued],[SiteID])
', 
N'Creating the missing indexes for the ThreadMod Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: 9874567894561256-AAA-42444ED-555B-4C514449668330F', 
N'
CREATE NONCLUSTERED INDEX [IX_ArticleMod_LockedBy_Status_ComplaintID_DateQueued_SiteID]
ON [dbo].[ArticleMod] ([LockedBy],[Status],[ComplainantID])
INCLUDE ([DateQueued],[SiteID])
', 
N'Creating the missing indexes for the ArticleMod Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: ABCANDFEFEAB897897-AAA-42444ED-555B-4C514449668330F', 
N'
/****** Object:  Index [IX_ExLinkMod_LockedBy_Status]    Script Date: 08/23/2012 12:28:12 ******/
CREATE NONCLUSTERED INDEX [IX_ExLinkMod_LockedBy_Status] ON [dbo].[ExLinkMod] 
(
	[LockedBy] ASC,
	[Status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
', 
N'Creating the missing indexes for the ArticleMod Table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: BAB755E1-6637-404F-9178-789456789456789456',
N'
TRUNCATE TABLE dbo.ContactForms

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ContactForms]'') AND name = N''IX_ContactFormss_HashedEmail'')
BEGIN
	DROP INDEX [IX_ContactFormss_HashedEmail] ON [dbo].[ContactForms] WITH ( ONLINE = OFF )
END

IF dbo.udf_columnexists(''dbo.ContactForms'',''EncryptedContactEmail'') = 1
BEGIN
	ALTER TABLE dbo.ContactForms DROP COLUMN EncryptedContactEmail
END

IF dbo.udf_columnexists(''dbo.ContactForms'',''HashedEmail'') = 1
BEGIN
	ALTER TABLE dbo.ContactForms DROP COLUMN HashedEmail
END

ALTER TABLE dbo.ContactForms ADD EncryptedContactEmail varbinary(8000) NULL
ALTER TABLE dbo.ContactForms ADD HashedEmail varbinary(900) NULL
CREATE NONCLUSTERED INDEX IX_ContactFormss_HashedEmail ON dbo.ContactForms(HashedEmail)
',
N'In ContactForms table, create EncryptedContactEmail and HashedEmail columns, and index on HashedEmail', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MarkH: BAB755E1-6637-404F-9178-ABCADABABDBDBABBAD8989865',
N'
TRUNCATE TABLE dbo.ThreadEntriesEncrypted

ALTER TABLE dbo.ThreadEntriesEncrypted ADD
	EncryptedText varbinary(8000) NOT NULL,
	HashedText varbinary(900) NOT NULL

ALTER TABLE dbo.ThreadEntriesEncrypted
	DROP COLUMN Text
	
CREATE NONCLUSTERED INDEX IX_ThreadEntriesEncrypted_HashedText ON dbo.ThreadEntriesEncrypted(HashedText)
',
N'In ThreadEntriesEncrypted table, create EncryptedThreadEntry and HashedText columns, and index on HashedText', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: SOMTHINGRANDOMASDF-AAA-42444ED-555B-4C51444ABABABBABA', 
N'
ALTER TABLE dbo.Sites ADD ContactFormsEmail varchar(255) NULL
', 
N'Adding the new Contact Forms Email column to the sites table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
	EXEC dbu_dosql N'MRH: 789456123456789456123-46A1-4f93-B67C-65E1B77DB47E', 
	N'
		--DotNetNormalUser
		update SignInUserIDMapping
		set IdentityUserID = 238011401921716226
		where dnauserid=1090501859

		--DotNetEditor
		update SignInUserIDMapping
		set IdentityUserID = 238011998234330627
		where dnauserid=1090558353

		--DotNetSuperUser
		update SignInUserIDMapping
		set IdentityUserID = 238006192378066947
		where dnauserid=1090558354
	', 
	N'Migrate smallguide test users to identity accounts.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN

	EXEC dbu_dosql N'MRH: 456123456789456123-46A1-4f93-B67C-65E1B77DB47E', 
	N'
		--ProfileAPITest
		update SignInUserIDMapping
		set IdentityUserID = 238010551434331139
		where dnauserid=1090498911

		--DotNetUserBanned
		update SignInUserIDMapping
		set IdentityUserID = 238011633464100099
		where dnauserid=1165333426

		--DotNetModerator
		update SignInUserIDMapping
		set IdentityUserID = 238012221169977091
		where dnauserid=1090564231

		--DotNetPreModUser
		update SignInUserIDMapping
		set IdentityUserID = 238012432193800195
		where dnauserid=1090565871

		--DotNetNotableUser
		update SignInUserIDMapping
		set IdentityUserID = 238012654592549122
		where dnauserid=1165233424

		--test_trusted
		update SignInUserIDMapping
		set IdentityUserID = 238012916451336706
		where dnauserid=1165333429
	', 
	N'Migrate smallguide test users to identity accounts.', @curerror OUTPUT
	IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'Sri: 1C9812D8-E797-4504-87Z1-CDFA1AE12341',
N'CREATE TABLE [dbo].[Top20MostCommentedForums](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[UID] [varchar](255) NOT NULL,
	[SiteId] [int] NOT NULL,
	[ForumId] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Url] [nvarchar](255) NOT NULL,
	[CanWrite] [tinyint] NULL,
	[ForumPostCount] [int] NOT NULL,
	[ModerationStatus] [tinyint] NULL,
	[DateCreated] [datetime] NULL,
	[ForumCloseDate] [datetime] NULL,
	[CommentForumListCount] [int] NOT NULL,
	[LastPosted] [datetime] NULL
) ON [PRIMARY]
',
N'Create table for storing top 20 most commented forums', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'Sri: 1D9812D8-0000-4504-87Z1-CDFA1AE10000',
N'sp_RENAME ''Top20MostCommentedForums'' , ''TopNMostCommentedForums''
',

N'Altering the table name from Top20MostCommentedForums to TopNMostCommentedForums', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: EMAILQUEUETABLE-AAA-42444ED-555B-ANDMORERANDOMCHARS', 
N'
CREATE TABLE dbo.EmailQueue
	(
	ID int NOT NULL IDENTITY (1, 1),
	ToEmailAddress varbinary(128) NOT NULL,
	FromEmailAddress varbinary(128) NOT NULL,
	Subject varbinary(256) NOT NULL,
	Body varbinary(MAX) NOT NULL,
	Notes nvarchar(MAX) NULL,
	Priority smallint NOT NULL,
	DateQueued datetime NOT NULL CONSTRAINT DF_EmailQueue_DateQueued DEFAULT GetDate(),
	DateSent datetime NULL,
	LastFailedReason nvarchar(MAX) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
', 
N'Adding the new EmailQueue table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 4f8d2db8-b8ab-4e04-9292-973729b6c9e4',
N'CREATE TABLE [dbo].[ThreadEntryDistressMessage](
	[ParentEntryId] [int] NOT NULL,
	[DistressMessageId] [int] NOT NULL
	) ON [PRIMARY]
',
N'Create table mapping a distress message to the parent message', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: 1e02921c-b800-450a-8857-21f64a76e0fe',
N'CREATE UNIQUE CLUSTERED INDEX [PK_ThreadEntryDistressMessage] ON [dbo].[ThreadEntryDistressMessage] 
(
	[ParentEntryId] ASC,
	[DistressMessageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]',
N'Create clustered index for hte ThreadEntryDistressMessage table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'djw: {12C55546-AEB8-4081-B658-EC2EC282F385}',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''General'', ''RTLSite'', ''0'', 0, ''Site language is right-to-left. HTML will be used for emails'')
',
N'Create RTLSite option for sites.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'djw: {3B9C5D75-8A6D-4292-B410-30271FB37D8B}',
N'
Update SiteOptions set [Type] = 1
Where [Name] = ''RTLSite''',
N'Change RTLSite option to be a bool.', @curerror OUTPUT
IF (@curerror <> 0) RETURN
EXEC dbu_dosql N'MRH: NEWINDEX-b800-450a-8857-21f64a76e0fe',
N'
CREATE NONCLUSTERED INDEX [IX-TermsByModClassHistory_ModClassID_TermID_UpdateID]
ON [dbo].[TermsByModClassHistory] ([modclassid])
INCLUDE ([termid],[updateid])
',
N'Creating non clustered index for TermsByModClassHistory table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: NEWINDEX-b800-450a-AAAA-21f64a76e0fe',
N'
CREATE NONCLUSTERED INDEX [IX-TermsByModClass_ModClassID_TermID_ActionID]
ON [dbo].[TermsByModClass] ([modclassid])
INCLUDE ([termid],[actionid])
',
N'Creating non clustered index for TermsByModClass table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MARKH-OPIOUIYU-Q*QWUUE-£"£HIHVNJ-NJBFEFf',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''General'', ''UseAtosEmailIngester'', ''0'', 1, ''Set ON if the site uses the Atos(WatchDog) Email Ingest system for Contact Forms'')
',
N'Created the new UseAtosEmailIngester site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MARKH-CFGCFGCFGCG-Q*QWUUE-£"£H(())NJ-NJBFEFf',
N'
INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description)
values 
(0, ''General'', ''SendEmailsViaDatabaseQueue'', ''0'', 1, ''Set ON if emails should be sent via the database queue'')
',
N'Created the new SendEmailsViaDatabaseQueue site option.', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI-3EC2F544-CC1C-42BE-A72F-8CB3FBB94C5E',
N'DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype(''ThreadModAwaitingEmailVerification'',''ComplaintText'')
IF @type IS NULL RAISERROR (''Failed to find type for column ComplaintText on ThreadModAwaitingEmailVerification'',16,1)
IF @type <> ''nvarchar''
BEGIN 
	Alter TABLE dbo.ThreadModAwaitingEmailVerification
	ALTER COLUMN ComplaintText NVARCHAR(MAX) NULL 

	UPDATE dbo.ThreadModAwaitingEmailVerification
	SET ComplaintText = ComplaintText
END
',
N'Altering the ComplainText columntype to NVARCHAR(MAX) and moving the text from LOB to the table (if less than 8000 bytes)', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI-3EC2F544-CC1C-42BE-A72F-8CB3FBB91111',
N'
IF dbo.udf_columnexists(''dbo.SiteUpdate'',''LastUpdated'') = 0
BEGIN
Alter TABLE dbo.SiteUpdate
ADD LastUpdated DATETIME DEFAULT GETDATE() NOT NULL
END
',
N'Adding a new column, LastUpdated with default as getdate()', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI-00C2F544-CC1C-42BE-A72F-8CB0000A91111',
N'
IF dbo.udf_columnexists(''dbo.EmailQueue'',''DateAdded'') = 0
BEGIN
Alter TABLE dbo.EmailQueue
ADD DateAdded DATETIME DEFAULT GETDATE() NOT NULL
END
',
N'Adding a new column, DateAdded with default as getdate()', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'SRI-00C2F544-CC1C-42BE-A72F-0000000A91222',
N'
IF dbo.udf_columnexists(''dbo.EmailQueue'',''DBMailId'') = 0
BEGIN
Alter TABLE dbo.EmailQueue
ADD DBMailId INT DEFAULT 0 NOT NULL
END
',
N'Adding a new column, DBMailId with default as 0', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'SRI-ZZAAF5XX-CC1C-42BE-A72F-0000000A9122A',
N'
IF dbo.udf_columnexists(''dbo.EmailQueue'',''DataQueued'') = 0
BEGIN
	ALTER TABLE dbo.EmailQueue
	ALTER COLUMN DateQueued DATETIME NULL
END
ELSE
BEGIN
	ALTER TABLE dbo.EmailQueue
	ADD DateQueued DATETIME NULL
END
',
N'Altering/adding a nullable new column, DateQueued', @curerror OUTPUT
IF (@curerror <> 0) RETURN

IF DB_NAME() = 'SmallGuide'
BEGIN
EXEC dbu_dosql N'MRH-JIIVNWIENVIWNVIWNEIVNIENVINEVIWNEIVNWEINVIEWNVIWNE',
N'
update Sites set IdentityPolicy = ''comment''
update SiteOptions set Value = ''1'' where Name = ''UseIDv4''
',
N'Making all site use iDv4 with comment policy for smallguide', @curerror OUTPUT
IF (@curerror <> 0) RETURN
END

EXEC dbu_dosql N'MRH: NEWINDEX-b800-wqfqwfqwfw-AAAA-21f64a76e0fe',
N'
CREATE NONCLUSTERED INDEX [IX_TermsByModClassHistory_TermID]
ON [dbo].[TermsByModClassHistory] ([termid])
',
N'Adding new TermID index to the TermsBymodClassHistory table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


EXEC dbu_dosql N'MRH: NEWINDEX-b800-450a-berbqerbqerbqerq-21f64a76e0fe',
N'
CREATE NONCLUSTERED INDEX [IX_TermsByModClass_TermID]
ON [dbo].[TermsByModClass] ([termid])
',
N'Adding new TermID index to the TermsBymodClass table', @curerror OUTPUT
IF (@curerror <> 0) RETURN

EXEC dbu_dosql N'MRH: NEWCOLUMN-b100-560a-berbqdsvsvewsvwevweqerq-21f64a76e0fe',
N'
ALTER TABLE dbo.EmailQueue ADD
	RetryAttempts int NULL
',
N'Adding new RetryAttempts column to EmailQueue table', @curerror OUTPUT
IF (@curerror <> 0) RETURN


------------------------------------------------------------------------------------------------
-- INSERT NEW CODE BEFORE HERE!!!

-- COMMIT TRANSACTION *MUST* be last line in this file	
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION 

-- Ensure ripley is part of the ripley role.  Has to be executed outside a transaction
EXEC sp_addrolemember N'ripleyrole', N'ripley'

--Recreate SmallGuide Snapshot. Create Database not permitted within transaction.
IF DB_NAME() = 'SmallGuide'
BEGIN
	--Create New SnapShot.
	DECLARE @filename VARCHAR(128), @SQL nvarchar(1000)
	SELECT @filename = physical_name
	FROM sys.master_files
	WHERE database_id = DB_ID('smallguidess')

	IF ( @filename IS NOT NULL )
	BEGIN
		DROP DATABASE SmallGuideSS
		SET @SQL = 'CREATE DATABASE SmallGuideSS ON 
		( NAME = SmallGuide, FILENAME = ''' + @filename + ''') AS SNAPSHOT OF SmallGuide'
		EXEC sp_executeSQL @SQL
		PRINT 'Recreating SmallGuide SnapShot'
	END
	
	--backup smallguide
	DECLARE @directory VARCHAR(128)
	SELECT @directory = substring(physical_name,0, CHARINDEX('smallguidess', physical_name))
	FROM sys.master_files
	WHERE database_id = DB_ID('smallguidess')

	IF ( @directory IS NOT NULL )
	BEGIN
		DECLARE @backupfilename VARCHAR(1000)
		select @backupfilename = @directory + 'smallguide.bak'

		BACKUP DATABASE [smallguide] TO  DISK = @backupfilename WITH NOFORMAT, INIT,  NAME = N'smallguide-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
		PRINT 'SmallGuide backed-up'
	END
END
