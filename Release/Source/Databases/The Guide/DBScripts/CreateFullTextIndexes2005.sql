/*

-- Run these commands to create the full text indexes in SQL Server 2005

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

CREATE FULLTEXT CATALOG VGuideEntryText_collectiveCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.VGuideEntryText_collective(Subject, text) KEY INDEX IX_VGuideEntryText_collective ON VGuideEntryText_collectiveCat WITH CHANGE_TRACKING AUTO
go

CREATE FULLTEXT CATALOG VGuideEntryText_memoryshareCat WITH ACCENT_SENSITIVITY = OFF
go
CREATE FULLTEXT INDEX ON dbo.VGuideEntryText_memoryshare(Subject, text) KEY INDEX IX_VGuideEntryText_memoryshare ON VGuideEntryText_memoryshareCat WITH CHANGE_TRACKING AUTO
go

*/

-- Run these commands to find out the current state of the catalogs
create table #temp (owner varchar(50),name varchar(50),indexname varchar(50),colid int,active int,catname varchar(50));
insert into #temp exec sp_help_fulltext_tables;
select  t.catname as 'catalogue', 
		count(t.name) as 'num tables',
		dbo.udf_GetFullTextCatalogPopulateStatusDescription(t.catname) AS 'status',
		FULLTEXTCATALOGPROPERTY(t.catname,'itemcount') AS 'itemcount', 
		dateadd(ss,FULLTEXTCATALOGPROPERTY(t.catname, 'PopulateCompletionAge'),'1/1/1990') as 'completed'
  from	#temp t
 group	by t.catname;
drop table #temp;

select	o.name AS 'table', 
		c.name AS 'catalogue',
		i.is_enabled,
		i.change_tracking_state_desc AS 'change tracking'		
  from	sys.fulltext_catalogs c
		INNER JOIN sys.fulltext_indexes i ON c.fulltext_catalog_id = i.fulltext_catalog_id
		INNER JOIN sys.objects o ON i.object_id = o.object_id;

/*

-- Run this to see if there are any tracked changes that are waiting to update the indexes
select *
  from sys.dm_fts_index_population

-- Run these commands to fully populate the catalogs
ALTER FULLTEXT CATALOG GuideEntriesCat REBUILD; 

ALTER FULLTEXT CATALOG ThreadEntriesCat REBUILD; 

ALTER FULLTEXT CATALOG HierarchyCat REBUILD; 

ALTER FULLTEXT CATALOG VGuideEntryText_collectiveCat REBUILD; 

ALTER FULLTEXT CATALOG VGuideEntryText_memoryshareCat REBUILD; 
*/

/*
-- Run these commands to remove all the catalogs
DROP FULLTEXT INDEX ON GuideEntries;
DROP FULLTEXT CATALOG GuideEntriesCat;

DROP FULLTEXT INDEX ON ThreadEntries;
DROP FULLTEXT CATALOG ThreadEntriesCat;

DROP FULLTEXT INDEX ON Hierarchy;
DROP FULLTEXT CATALOG HierarchyCat;

DROP FULLTEXT INDEX ON VGuideEntryText_collective;
DROP FULLTEXT CATALOG VGuideEntryText_collectiveCat;

DROP FULLTEXT INDEX ON VGuideEntryText_memoryshare;
DROP FULLTEXT CATALOG VGuideEntryText_memoryshareCat;

*/