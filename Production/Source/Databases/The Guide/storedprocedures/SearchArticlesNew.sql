CREATE PROCEDURE searcharticlesnew
						@subjectcondition varchar(1000),
						@bodycondition varchar(1000) = @subjectcondition,
						@shownormal int = 1,
						@showsubmitted int = 1,
						@showapproved int = 1,
						@primarysite int = 1,
						@scoretobeat real = 0.0,
						@maxresults int = null,
						@withincategory int = null
AS
-- make sure ScoreToBeat has sensible value
if (@scoretobeat is null) set @scoretobeat = 0.0
-- max results of null or zero means no maximum (a million should suffice though)
if (@maxresults is null or @maxresults = 0) set @maxresults = 1000000

/* replace any single quotes with double single quotes, otherwise they will break the query */
--set @subjectcondition = replace(@subjectcondition, '''', '''''')
--set @bodycondition = replace(@bodycondition, '''', '''''')

declare @Query varchar(4000)
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
								WHERE m.NodeID = ' + CAST(@withincategory as varchar) + ' 
								OR m.NodeID IN (SELECT a.NodeID FROM Ancestors a WHERE a.AncestorID = ' + CAST(@withincategory as varchar) + ')
								OR m.NodeID IN (SELECT l.LinkNodeID FROM HierarchyNodeAlias l WHERE l.NodeID = ' + CAST(@withincategory as varchar) + ' OR l.NodeID IN (SELECT a1.NodeID FROM Ancestors a1 WHERE a1.AncestorID = ' + CAST(@withincategory as varchar) + ')))'
END

delete from guidetextsearch where searchdate < dateadd(hour,-12,getdate())
delete from guidesubjectsearch where searchdate < dateadd(hour,-12,getdate())

if NOT EXISTS (SELECT * from guidetextsearch where searchterm = @bodycondition) AND NOT EXISTS (SELECT * from guidesubjectsearch where searchterm = @subjectcondition)
BEGIN
	insert into guidetextsearch (searchterm, [KEY],RANK, searchdate)
	select @bodycondition, [KEY], RANK, getdate()
	from	containstable(GuideEntries, text, @bodycondition)
	IF NOT EXISTS (SELECT * from guidetextsearch where searchterm = @bodycondition)
	BEGIN
		INSERT INTO guidetextsearch(searchterm, [KEY],RANK, searchdate)
		VALUES (@bodycondition,NULL,0.0,getdate())
	END
	insert into guidesubjectsearch (searchterm, [KEY],RANK, searchdate)
	select @subjectcondition, [KEY], RANK, getdate()
	from	containstable(guideentries, Subject, @subjectcondition)
	IF NOT EXISTS (SELECT * from guidesubjectsearch where searchterm = @subjectcondition)
	BEGIN
		INSERT INTO guidesubjectsearch(searchterm, [KEY],RANK, searchdate)
		VALUES (@subjectcondition,NULL,0.0,getdate())
	END

END
select 
	G.EntryID, G.h2g2ID, G.BlobID, G.Subject, G.Status, G.SiteID,G.DateCreated,G.LastUpdated, 'PrimarySite' = CASE WHEN G.SiteID = @primarysite THEN 1 ELSE 0 END,
	'SubjectRank' = 0.0,
	'TextRank' = TextKeyTable.rank,
	'Score' = sqrt((@TextBias        * TextKeyTable.rank)
			* case
			when (G.Status = 1 or G.Status = 9) then (@ApprovedMultiplier     )
			when G.Status = 4 then (@SubmittedMultiplier    )
			when G.Status = 3 then (@NormalMultiplier    )
			else (@DefaultMultiplier    )
		      end)
			  , G.ExtraInfo
from	GuideEntries G WITH(NOLOCK)
	inner join guidetextsearch as TextKeyTable ON TextKeyTable.searchterm = @bodycondition
	AND G.BlobID = TextKeyTable.[key]
where	
	--G.Status in (4,1,9,3,4,5,6,8,11,12,13)
	(
		(@showapproved = 1 AND G.Status IN (1,9)) OR
		(@showsubmitted = 1 AND G.Status = 4) OR
		(@shownormal = 1 AND G.Status IN (3,4,5,6,8,11,12,13))
	)
	and G.Hidden is null
	and sqrt(
		(@TextBias        * TextKeyTable.rank) *
		case
			when (G.Status = 1 or G.Status = 9) then (@ApprovedMultiplier     )
			when G.Status = 4 then (@SubmittedMultiplier    )
			when G.Status = 3 then (@NormalMultiplier    )
			else (@DefaultMultiplier    )
		end) > 0
UNION ALL
select 
	G.EntryID, G.h2g2ID, G.BlobID, G.Subject, G.Status, G.SiteID, G.DateCreated, G.LastUpdated,'PrimarySite' = CASE WHEN G.SiteID = @primarysite THEN 1 ELSE 0 END,
	'SubjectRank' = SubjectKeyTable.rank,
	'TextRank' = 0.0,
	'Score' = sqrt((@SubjectBias        * SubjectKeyTable.rank)* 
		case
			when (G.Status = 1 or G.Status = 9) then (@ApprovedMultiplier     )
			when G.Status = 4 then (@SubmittedMultiplier    )
			when G.Status = 3 then (@NormalMultiplier    )
			else (@DefaultMultiplier    )
		      end)
			  , G.ExtraInfo
from	GuideEntries G WITH(NOLOCK)
	inner join guidesubjectsearch as SubjectKeyTable
	on G.EntryID = SubjectKeyTable.[key] AND SubjectKeyTable.searchterm = @bodycondition
where	
	--AND SubjectKeyTable.searchterm = 'isabout("charlotte" weight(0.5),formsof(inflectional, "charlotte") weight(0.25),"charlotte" weight(1.0))'
	--G.Status in (4,1,9,3,4,5,6,8,11,12,13)
	(
		(@showapproved = 1 AND G.Status IN (1,9)) OR
		(@showsubmitted = 1 AND G.Status = 4) OR
		(@shownormal = 1 AND G.Status IN (3,4,5,6,8,11,12,13))
	)
	and G.Hidden is null
	and sqrt(
		(0.7        * SubjectKeyTable.rank) *
		case
			when (G.Status = 1 or G.Status = 9) then (@ApprovedMultiplier     )
			when G.Status = 4 then (@SubmittedMultiplier    )
			when G.Status = 3 then (@NormalMultiplier    )
			else (@DefaultMultiplier    )
		end) > 0


order by PrimarySite desc, Score desc, G.Status asc

	RETURN 
