/*
Searches articles and ranks them based on the search conditions given


*/

create procedure searcharticlesfast
						@top int,
						@condition varchar(1000),
						@shownormal int = 1,
						@showsubmitted int = 1,
						@showapproved int = 1,
						@usergroups varchar(256) = null,
						@primarysite int = 1,
						@maxresults int = null,
						@withincategory int = null,
						@showcontentratingdata int = 0,
						@articletype int = null,
						@showkeyphrases int = 0
as
-- max results of null or zero means internal maximum
if (ISNULL(@maxresults,0) = 0) set @maxresults = 2000

/* replace any single quotes with double single quotes, otherwise they will break the query */
--set @condition = replace(@condition, '''', '''''')

declare @Query nvarchar(4000)
declare @StatusList varchar(64)

/* calculate the list of valid status values to include in the search results */
set @StatusList = ''
if @showsubmitted = 1 begin set @StatusList = ',4' end
if @showapproved = 1 begin set @StatusList = @StatusList + ',1,9' end
if @shownormal = 1 begin set @StatusList = @StatusList + ',3,4,5,6,8,11,12,13' end
set @StatusList = substring(@StatusList, 2, len(@StatusList)-1)

declare @catclause varchar(1000)
if (@withincategory IS NULL)
BEGIN
	SELECT @catclause = ''
END
ELSE
BEGIN
	SELECT @catclause = 'and G.EntryID IN (
							select m.EntryID FROM HierarchyArticleMembers m WITH(NOLOCK)
								WHERE m.NodeID = @i_withincategory 
								OR m.NodeID IN (SELECT a.NodeID FROM Ancestors a WITH(NOLOCK) WHERE a.AncestorID = @i_withincategory)
								OR m.NodeID IN (SELECT l.LinkNodeID FROM HierarchyNodeAlias l WITH(NOLOCK) WHERE l.NodeID = @i_withincategory 
								OR l.NodeID IN (SELECT a1.NodeID FROM Ancestors a1 WITH(NOLOCK) WHERE a1.AncestorID = @i_withincategory)))'
END

declare @articletypeclause varchar(1000)
if (@articletype is null)
begin
	select @articletypeclause = ''
end
else
begin
	select @articletypeclause = 'and g.type = @i_articletype '
end

-- User Group clause - Filter on User Group of editor.
DECLARE @groupclause VARCHAR(512)
SET @groupclause = ''
IF NOT @usergroups IS NULL
BEGIN
 SET @groupclause =  ' INNER JOIN GROUPMEMBERS gm WITH(NOLOCK) ON gm.UserID = g.Editor AND gm.SiteID = g.SiteID ' 
 SET @groupclause =  @groupclause + ' INNER JOIN dbo.udf_splitvarcharwithdelimiter(@i_usergroups, '','') ug ON gm.GroupID = ug.element '
END

-- Set ContentRatingData fields and join tables
declare @ContentRatingDataSelect varchar(100)
declare @ContentRatingDataJoin varchar(200)

if(@showcontentratingdata = 1) begin
	set @ContentRatingDataSelect = ',pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount'
	set @ContentRatingDataJoin 	= 
	' left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1
	  left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 '
end else begin
	set @ContentRatingDataSelect = ''
	set @ContentRatingDataJoin = ''
end

DECLARE @keyphrasesclause VARCHAR(1024)
DECLARE @keyphrasesselect VARCHAR(1024)
IF ( @showkeyphrases = 1 ) 
BEGIN
	SET @keyphrasesselect = ',n.name ''namespace'', kp.phrase '
	SET @keyphrasesclause = ' LEFT JOIN  articlekeyphrases akp WITH(NOLOCK) ON akp.entryid = g.entryid 
							LEFT JOIN phrasenamespaces pn WITH(NOLOCK) ON pn.phrasenamespaceid = akp.phrasenamespaceid 
							LEFT JOIN keyphrases kp WITH(NOLOCK) ON kp.phraseid = pn.phraseid 
							LEFT JOIN namespaces n WITH(NOLOCK) ON n.namespaceid = pn.namespaceid '
							

END
ELSE
BEGIN
	SET @keyphrasesclause = ''
	SET @keyphrasesselect = ''
END

DECLARE @fulltextindex VARCHAR(255);
SELECT @fulltextindex = dbo.udf_getguideentryfulltextcatalogname(@primarysite); -- The most appropriate object to full text search against (may be site specific indexed view). 

set @Query = '

select top(@i_top)
	G.EntryID, G.h2g2ID, G.BlobID, G.Subject, G.Status, G.SiteID, G.DateCreated, G.LastUpdated,G.Type,
	''PrimarySite'' = CASE WHEN G.SiteID = @i_primarysite THEN 1 ELSE 0 END,
	''Rank'' = KeyTable.rank,
	''Score'' = CAST(KeyTable.rank AS float)*.001,
	G.ExtraInfo 
	' + @ContentRatingDataSelect + '
	' + @keyphrasesselect + '
   ,ar.startdate,
	ar.enddate,
	ar.timeinterval
   from CONTAINSTABLE(' + @fulltextindex + ',(subject,text),@i_condition,@i_maxsearchresults) KeyTable
	INNER join guideentries g WITH(NOLOCK) on g.entryid = KeyTable.[key]
	LEFT JOIN articledaterange ar with(nolock) on g.entryid = ar.entryid 
	' + @ContentRatingDataJoin + ' 
	' + @groupclause + ' 
	' + @keyphrasesclause + '
	where G.Status in (' + @StatusList + ')
	and G.Hidden is null and g.siteid=@i_primarysite
	'
	+ @catclause +
	+ @articletypeclause + '
	order by CASE WHEN G.SiteID = @i_primarysite THEN 0 ELSE 1 END, KeyTable.rank desc, G.Status asc'

--print 'Subject condition is: ' + @subjectcondition
--print 'Body condition is: ' + @bodycondition
--print 'Query string is: ' + @Query

exec sp_executesql @Query, 
N'@i_top int,
@i_maxsearchresults int, 
@i_condition varchar(4000), 
@i_primarysite int,
@i_withincategory int,
@i_articletype int,
@i_usergroups varchar(256)',
@i_top = @top, 
@i_maxsearchresults = @maxresults, 
@i_condition = @condition,
@i_primarysite = @primarysite,
@i_withincategory = @withincategory,
@i_articletype = @articletype, 
@i_usergroups = @usergroups