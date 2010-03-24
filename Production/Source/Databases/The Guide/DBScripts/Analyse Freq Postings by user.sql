/*
mbs have a default and site-wide value.  It picks the greater

look for posts in just one site at a time, within a monthly time frame
for each user that posted, work out the time delay between posts
count how many posts would have been rejected with 

*/

IF OBJECTPROPERTY ( object_id('t_FreqUserPostings'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE t_FreqUserPostings
GO
CREATE PROCEDURE t_FreqUserPostings @tablename varchar(100),@urlname varchar(50),@start varchar(50), @end varchar(50)
AS

declare @siteid varchar(10)
select @siteid = cast(siteid as varchar(10)) from sites where urlname=@urlname

IF OBJECTPROPERTY ( object_id(@tablename),'IsUserTable') IS NOT NULL
	exec('drop table '+@tablename)

exec ('create table '+@tablename+' (id int NOT NULL IDENTITY (1, 1), userid int, entryid int, dateposted datetime)')
exec ('create index ix_'+@tablename+' ON '+@tablename+' (id)')

exec ('insert '+@tablename+'
	select userid, entryid, dateposted from threadentries te
	inner join forums f on te.forumid=f.forumid and f.siteid='+@siteid+'
	where te.dateposted >= '''+@start+''' and te.dateposted < '''+@end+'''
	order by userid,entryid')

exec ('alter table '+@tablename+' add diff int')

exec ('update '+@tablename+' set '+@tablename+'.diff=datediff(second,t2.dateposted,'+@tablename+'.dateposted)
	from '+@tablename+'
	inner join '+@tablename+' t2 on t2.id = '+@tablename+'.id-1
	where '+@tablename+'.userid=t2.userid')


exec ('select c1 ''total'',c1-c2 ''remaining'', (c1-c2)/(c1*1.) ''diff'' from 
	(select count(*) c1 from '+@tablename+') t1,
	(select count(*) c2 from '+@tablename+' where diff > 60) t2')
GO

IF OBJECTPROPERTY ( object_id('t_FreqUserPostingsCount'),'IsProcedure') IS NOT NULL
	DROP PROCEDURE t_FreqUserPostingsCount
GO
CREATE PROCEDURE t_FreqUserPostingsCount @tablename varchar(100),@limit varchar(5)
AS
exec ('select '''+@tablename+''' ''Table'','+@limit+' ''limit'', c1 ''total'',c2 ''qualified'',c1-c2 ''remaining'', (c1-c2)/(c1*1.) ''diff'' from 
	(select count(*) c1 from '+@tablename+') t1,
	(select count(*) c2 from '+@tablename+' where diff > '+@limit+') t2')
GO

exec t_FreqUserPostings 'ThreadPostsFansForumFeb','mbfansforum','2006-02-01','2006-03-01'
exec t_FreqUserPostings 'ThreadPosts606Feb',      'mb606','2006-02-01','2006-03-01'
exec t_FreqUserPostings 'ThreadPosts5LiveFeb',    'mbfivelive','2006-02-01','2006-03-01'
exec t_FreqUserPostings 'ThreadPostsWeatherFeb',  'mbweather','2006-02-01','2006-03-01'

exec t_FreqUserPostingsCount 'ThreadPostsFansForumFeb',60
exec t_FreqUserPostingsCount 'ThreadPosts606Feb',60
exec t_FreqUserPostingsCount 'ThreadPosts5LiveFeb',60
exec t_FreqUserPostingsCount 'ThreadPostsWeatherFeb',60

------

exec t_FreqUserPostings 'ThreadPostsFansForumJan','mbfansforum','2006-01-01','2006-02-01'
exec t_FreqUserPostings 'ThreadPosts606Jan',      'mb606','2006-01-01','2006-02-01'
exec t_FreqUserPostings 'ThreadPosts5LiveJan',    'mbfivelive','2006-01-01','2006-02-01'
exec t_FreqUserPostings 'ThreadPostsWeatherJan',  'mbweather','2006-01-01','2006-02-01'

exec t_FreqUserPostingsCount 'ThreadPostsFansForumJan',60
exec t_FreqUserPostingsCount 'ThreadPosts606Jan',60
exec t_FreqUserPostingsCount 'ThreadPosts5LiveJan',60
exec t_FreqUserPostingsCount 'ThreadPostsWeatherJan',60

select * from ThreadPostsWeatherFeb
order by diff

