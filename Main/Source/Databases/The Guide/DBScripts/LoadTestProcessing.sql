IF OBJECTPROPERTY ( object_id('loadtest_createspnamecolumn'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE loadtest_createspnamecolumn
GO
CREATE PROCEDURE loadtest_createspnamecolumn @tablename varchar(100)
AS
IF COLUMNPROPERTY(object_id(@tablename), 'spname', 'precision') IS NULL
BEGIN
	DECLARE @sql varchar(8000)

	SET @sql = 'ALTER TABLE '+@tablename+' ADD spname varchar(1000) NULL'
	EXEC (@sql)
	PRINT 'Added spname column'

	SET @sql = 'UPDATE '+@tablename+' SET spname =
		CASE CHARINDEX('' '',SUBSTRING(TextData,CHARINDEX(''.'',TextData),1000))
			WHEN 0 
			THEN
				SUBSTRING(TextData,CHARINDEX(''.'',TextData)+1,1000)
			ELSE
				SUBSTRING(SUBSTRING(TextData,CHARINDEX(''.'',TextData)+1,1000), 1,CHARINDEX('' '',SUBSTRING(TextData,CHARINDEX(''.'',TextData)+1,1000))-1)
		END'
	EXEC (@sql)
	PRINT 'Populated spname column'
END
GO

IF OBJECTPROPERTY ( object_id('loadtest_cleanuptable'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE loadtest_cleanuptable
GO
CREATE PROCEDURE loadtest_cleanuptable @tablename varchar(100)
AS
	PRINT 'Removing calls to sp_reset_connection'
	EXEC ('delete from '+@tablename+' where textdata like ''%exec sp_reset_connection%''')

	PRINT 'removing NULL textdata'
	EXEC ('delete from '+@tablename+' where textdata is null')
GO

IF OBJECTPROPERTY ( object_id('loadtest_getdata'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE loadtest_getdata
GO
CREATE PROCEDURE loadtest_getdata @tablename varchar(100), @orderby varchar(100)
AS
	DECLARE @sql varchar(8000)
	SET @sql = '
	select spname, count(*) numCalls, avg(reads) avgReads, sum(reads) SumReads, avg(duration) AvgDuration, sum(duration) SumDuration
	from '+@tablename+'
	where eventclass=10 -- only RPC:Completed considered
	group by spname
	order by '+@orderby
	EXEC (@sql)
GO

IF OBJECTPROPERTY ( object_id('loadtest_checkzero'),'IsScalarFunction') IS NOT NULL
	DROP FUNCTION  loadtest_checkzero
GO
CREATE FUNCTION loadtest_checkzero(@n BIGINT)
RETURNS REAL
AS
BEGIN
	IF (@n=0) RETURN 0.00000001 -- a number effectively as small as zero
	RETURN @n
END
GO

IF OBJECTPROPERTY ( object_id('loadtest_comparetests'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE loadtest_comparetests
GO
CREATE PROCEDURE loadtest_comparetests @tablename1 varchar(100), @tablename2 varchar(100)
AS
	CREATE TABLE #t1 (spname varchar(500),numCalls int, avgReads bigint, SumReads bigint, avgDuration bigint, sumDuration bigint)
	CREATE TABLE #t2 (spname varchar(500),numCalls int, avgReads bigint, SumReads bigint, avgDuration bigint, sumDuration bigint)

	INSERT INTO #t1 EXEC loadtest_getdata @tablename1,'spname'
	INSERT INTO #t2 EXEC loadtest_getdata @tablename2,'spname'

	SELECT *,
		ISNULL(t1.numCalls/dbo.loadtest_checkzero(t2.numcalls),0) 	numCalls,
		ISNULL(t1.avgReads/dbo.loadtest_checkzero(t2.avgReads),0) 	avgReads,
		ISNULL(t1.SumReads/dbo.loadtest_checkzero(t2.SumReads),0) 	SumReads,
		ISNULL(t1.avgDuration/dbo.loadtest_checkzero(t2.avgDuration),0) avgDuration,
		ISNULL(t1.sumDuration/dbo.loadtest_checkzero(t2.sumDuration),0) sumDuration
	FROM #t1 t1
	FULL JOIN #t2 t2 ON t1.spname=t2.spname
	ORDER BY t1.spname,t2.spname

	DROP TABLE #t1
	DROP TABLE #t2
GO

declare @tablename1 varchar(100), @tablename2 varchar(100)
set @tablename1='lt_060905_2997_n4_n8to15'
set @tablename2='lt_060905_3010_n4_n8to15'

exec loadtest_createspnamecolumn @tablename1
exec loadtest_cleanuptable @tablename1

exec loadtest_createspnamecolumn @tablename2
exec loadtest_cleanuptable @tablename2

select * from lt_060905_2997_n4_n8to15 where spname='threadlistpostheaders2' order by cast(TextData as varchar(max))
select * from lt_060905_3010_n4_n8to15 where spname='threadlistpostheaders2' order by cast(TextData as varchar(max))

select top 1000 * from lt_060905_3010_n4_n8to15 order by rowcounts desc

--exec loadtest_getdata @tablename,'spname'
--exec loadtest_getdata @tablename1,'sumreads desc'
--exec loadtest_getdata @tablename2,'sumreads desc'
--exec loadtest_getdata @tablename,'numcalls desc'

exec loadtest_comparetests @tablename1,@tablename2

--select * from lt_060803_2992_n4_n8to15 where spname='getallvotinguserswithresponse'

--select * from lt_060803_2992_n4_n8to15 where spname='iseditoronanysite'

/*
select * from lt_060321_2940_n8 where spname='forumgetthreadlist'


select * from lt_060424_2940_n8_n14_n4 where spname='posttoforum' order by duration desc
--select * from lt_060424_2940_n8_n14_n4 where spname='getthreadpostcontents' order by duration desc

select * from lt_060424_2962_n8_n14_n4 where spname='posttoforum' order by duration desc
--select * from lt_060424_2962_n8_n14_n4 where spname='getthreadpostcontents' order by duration desc

select avg(duration) from (select duration, count(*) as c from lt_060424_2940_n8_n14_n4
		where spname='posttoforum' 
		group by duration
		) s
where duration < 1000 and duration > 0
--order by c desc

select avg(duration) from (select duration, count(*) as c from lt_060424_2962_n8_n14_n4
		where spname='posttoforum' 
		group by duration
		) s
where duration < 1000 and duration > 0


select avg(reads) from (select duration, count(*) as c from lt_060424_2940_n8_n14_n4
		where spname='posttoforum' 
		group by duration
		) s
where duration < 1000 and duration > 0
--order by c desc

select avg(reads) from (select duration, count(*) as c from lt_060424_2962_n8_n14_n4
		where spname='posttoforum' 
		group by duration
		) s
where duration < 1000 and duration > 0


select * from lt_060424_2940_n8_n14_n4 where spname='posttoforum' order by reads desc
select * from lt_060424_2962_n8_n14_n4 where spname='posttoforum' order by reads desc
select avg(reads) from lt_060424_2940_n8_n14_n4 where spname='posttoforum'
select avg(reads) from lt_060424_2962_n8_n14_n4 where spname='posttoforum'

select * from lt_060424_2940_n8_n14_n4 where rownumber between 421000 and 422100 order by RowNumber

select * from lt_060424_2962_n8_n14_n4 where rownumber between 421000 and 422100 order by RowNumber

select * from lt_060424_2940_n8_n14_n4 where spname='threadlistposts2' order by reads desc
select * from lt_060424_2962_n8_n14_n4 where spname='threadlistposts2' order by reads desc

select count(*) from lt_060424_2940_n8_n14_n4 where spname='isusersubscribed'
select count(*) from lt_060424_2940_n8_n14_n4 where spname='markthreadread'

select count(*) from lt_060424_2962_n8_n14_n4 where spname='isusersubscribed'
select count(*) from lt_060424_2962_n8_n14_n4 where spname='markthreadread'
select count(*) from lt_060426_2962_n8_n14_n4 where spname='markthreadread'

select top 100 * from lt_060424_2962_n8_n14_n4 where rownumber > 94
*/
