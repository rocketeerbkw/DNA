/*
Searches articles and ranks them based on the search conditions given

Uses two containstable searches, one on the subject and one on the body, and weights the final score
with a bias of 9:1 towards the rank returned by the subject query

The from clause contains two joins - the first is a right outer join between the keys table produced from
the body text and the GuideEntries table, linked on the BlobID of the text blob. The second is a left outer
join on the result of this and the keys table produces from the subject text, linked on the EntryID of the
article. The where clause then limits the result set to entries which get a non-null rank in at least one of
the keys tables and have the appropriate status.

The final score is obtained by combining the two ranks with a bias towards the subject ranking, which requires
a sequence of case statements to cope with null values in either keys table and the different weightings given
to each type of Guide Entry.
*/

/*	Jamesp, 08/03/05 -	New Param, ShowContentRatingData: Set to 1 to return the following fields:

						CRPollID:			ID of ContentRating poll associated with article
						CRAverageRating:	Average content rating for article
						CRVoteCount:		Number of content rating votes for article
*/

CREATE procedure searcharticlesadvanced
						@subjectcondition varchar(1000),
						@bodycondition varchar(1000) = @subjectcondition,
						@shownormal int = 1,
						@showsubmitted int = 1,
						@showapproved int = 1,
						@usergroups varchar(256) = null,
						@primarysite int = 1,
						@scoretobeat real = 0.0,
						@maxresults int = null,
						@withincategory int = null,
						@showcontentratingdata int = 0,
						@articletype int = null,
						@showkeyphrases int = 0,
						@articlestatus int = null
as
-- make sure ScoreToBeat has sensible value
if (@scoretobeat is null) set @scoretobeat = 0.0
-- max results of null or zero means internal maximum
if (@maxresults is null or @maxresults = 0) set @maxresults = 2000

/* replace any single quotes with double single quotes, otherwise they will break the query */
DECLARE @SafeSubjectCondition varchar(2000)
DECLARE @SafeBodyCondition varchar(2000)
set @SafeSubjectCondition = replace(@subjectcondition, '''', '''''')
set @SafeBodyCondition = replace(@bodycondition, '''', '''''')

declare @Query nvarchar(4000)
declare @StatusList varchar(64)

/* calculate the list of valid status values to include in the search results */
set @StatusList = ''
if @showsubmitted = 1 begin set @StatusList = ',4' end
if @showapproved = 1 begin set @StatusList = @StatusList + ',1,9' end
if @shownormal = 1 begin set @StatusList = @StatusList + ',3,4,5,6,8,11,12,13' end
set @StatusList = substring(@StatusList, 2, len(@StatusList)-1)

/* various constants for weighting the final score */
declare @SubjectBias float
declare @TextBias float
declare @ApprovedMultiplier float
declare @SubmittedMultiplier float
declare @NormalMultiplier float
declare @DefaultMultiplier float


/* change these values for different weightings */
set @SubjectBias = 0.7
set @TextBias = 0.3
set @ApprovedMultiplier = 0.001
set @SubmittedMultiplier = 0.0005
set @NormalMultiplier = 0.0004
set @DefaultMultiplier = 0.0004

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
	select @articletypeclause = 'and g.type = ' + cast(@articletype as varchar) + ' '
end

declare @articlestatusclause varchar(1000)
if (@articlestatus is null)
begin
	select @articlestatusclause = ''
end
else
begin
	select @articlestatusclause = 'and g.status = ' + cast(@articlestatus as varchar) + ' '
end

-- User Group clause - Filter on User Group of editor.
DECLARE @groupclause VARCHAR(512)
SET @groupclause = ''
IF NOT @usergroups IS NULL
BEGIN
 SET @groupclause =  ' INNER JOIN GROUPMEMBERS gm WITH(NOLOCK) ON gm.UserID = g.Editor AND gm.SiteID = g.SiteID '
 SET @groupclause =  @groupclause + ' INNER JOIN dbo.udf_splitvarcharwithdelimiter(@i_usergroups, '','') ug ON gm.GroupID = ug.element '
END

DECLARE @scoreclause varchar(500)
SET @scoreclause =' sqrt((ISNULL(SubjectKeyTable.rank,0)*@i_subjectbias + ISNULL(TextKeyTable.rank,0)*@i_textbias)
		    * case
			when (G.Status = 1 or G.Status = 9) then (@i_approvedmultiplier)
			when G.Status = 4 then (@i_submittedmultiplier)
			when G.Status = 3 then (@i_normalmultiplier)
			else (@i_defaultmultiplier)
		      end)'
		      
		      
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


set @Query = '
declare @subkeytable TABLE([key] int, rank int)
insert into @subkeytable ([key], rank)
select [key], rank from CONTAINSTABLE(GuideEntries,subject,@i_subjectcondition,@i_top)

declare @textkeytable TABLE([key] int, rank int)
insert into @textkeytable ([key], rank)
select [key], [rank] from containstable(Guideentries,text,@i_bodycondition,@i_top)

select top(@i_top)
	G.EntryID, G.h2g2ID, G.BlobID, G.Subject, G.Status, G.SiteID, G.DateCreated, G.LastUpdated,G.Type,
	''PrimarySite'' = CASE WHEN G.SiteID = @i_primarysite THEN 1 ELSE 0 END,
	''SubjectRank'' = SubjectKeyTable.rank,
	''TextRank'' = TextKeyTable.rank,
	''Score'' = ' + @scoreclause + ',
	G.ExtraInfo 
	' + @ContentRatingDataSelect + '
	' + @keyphrasesselect + '
   ,ar.startdate,
	ar.enddate,
	ar.timeinterval
   from 	@subkeytable SubjectKeyTable
	full join @textkeytable TextKeyTable on SubjectKeyTable.[key] = TextKeyTable.[key]
	left join guideentries g WITH(NOLOCK) on g.entryid = SubjectKeyTable.[key] or g.entryid = TextKeyTable.[key] 
	left join articledaterange ar with(nolock) on g.entryid = ar.entryid 
	' + @ContentRatingDataJoin + ' 
	' + @groupclause + ' 
	' + @keyphrasesclause + '
	where (SubjectKeyTable.Rank is not null or TextKeyTable.Rank is not null)
	and G.Status in (' + @StatusList + ')
	and G.Hidden is null
	'
	+ @catclause +
	+ @articletypeclause +
	+ @articlestatusclause +
	'and sqrt(
		case
			when SubjectKeyTable.rank is null and TextKeyTable.rank is null then (0.0)
			when SubjectKeyTable.rank is null then (@i_textbias * TextKeyTable.rank)
			when TextKeyTable.rank is null then (@i_subjectbias * SubjectKeyTable.rank)
			else (@i_subjectbias * SubjectKeyTable.rank + @i_textbias * TextKeyTable.rank)
		end *
		case
			when (G.Status = 1 or G.Status = 9) then (@i_approvedmultiplier)
			when G.Status = 4 then (@i_submittedmultiplier)
			when G.Status = 3 then (@i_normalmultiplier)
			else (@i_defaultmultiplier)
		end) > @i_scoretobeat
order by CASE WHEN G.SiteID = @i_primarysite THEN 0 ELSE 1 END, Score desc, G.Status asc /* xyzzy */'

--print 'Subject condition is: ' + @subjectcondition
--print 'Body condition is: ' + @bodycondition
--print 'Query string is: ' + @Query

exec sp_executesql @Query, 
N'@i_top int, 
@i_subjectcondition varchar(4000), 
@i_bodycondition varchar(4000),
@i_primarysite int,
@i_textbias float,
@i_subjectbias float,
@i_approvedmultiplier float,
@i_submittedmultiplier float,
@i_normalmultiplier float,
@i_defaultmultiplier float,
@i_withincategory int,
@i_scoretobeat real,
@i_usergroups varchar(256)',
@i_top = @maxresults, 
@i_subjectcondition = @SafeSubjectCondition,
@i_bodycondition = @SafeBodyCondition,
@i_primarysite = @primarysite,
@i_textbias = @TextBias,
@i_subjectbias = @SubjectBias,
@i_approvedmultiplier = @ApprovedMultiplier,
@i_submittedmultiplier = @SubmittedMultiplier,
@i_normalmultiplier = @NormalMultiplier,
@i_defaultmultiplier = @DefaultMultiplier,
@i_withincategory = @withincategory,
@i_scoretobeat = @scoretobeat,
@i_usergroups = @usergroups
