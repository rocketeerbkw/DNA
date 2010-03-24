/*
Searches posts and ranks them based on the search conditions given
*/

create procedure searchthreadentriesfast
						@siteid int = null,
						@condition varchar(1000)
as

DECLARE @fulltextindex VARCHAR(255);
declare @Query nvarchar(4000)

SELECT @fulltextindex = dbo.udf_getthreadentryfulltextcatalogname(@siteid); -- The most appropriate object to full text search against (will be site specific indexed view). 
--SELECT @fulltextindex = 'VThreadEntryText_mbfivelive'; -- The most appropriate object to full text search against (will be site specific indexed view). 

PRINT @fulltextindex

set @Query = '
SELECT te.EntryID, 
	te.ForumID, 
	te.ThreadID, 
	te.Subject, 
	te.text, 
	te.DatePosted, 
	te.LastUpdated, 
	te.PostStyle,
	te.PostIndex,
	te.Hidden,
	te.UserID,
	''Rank'' = KeyTable.rank,
	''Score'' = CAST(KeyTable.rank AS float)*.001 
   FROM CONTAINSTABLE(' + @fulltextindex + ', text, @i_condition, @i_maxsearchresults) KeyTable
	INNER join threadentries te WITH(NOLOCK) on te.entryid = KeyTable.[key]
	WHERE te.Hidden is null
	ORDER BY KeyTable.rank DESC'
--print 'Query string is: ' + @Query

exec sp_executesql @Query, 
N'@i_maxsearchresults int, 
@i_condition varchar(4000)',
@i_maxsearchresults = 100, 
@i_condition = @condition