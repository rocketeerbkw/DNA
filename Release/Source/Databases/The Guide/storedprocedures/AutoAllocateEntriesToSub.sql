/*
	Allocates the given number of entries to the sub from the recommended
	entries queue, in order that they were submitted. 

	Note: @comments parameter is limited to 7500 chars here since 8000 is the
	largest size the query string can have. To allow anything larger could result
	in the query string being to large and the SP simply failing. This solution
	is not perfect because it means the comments could be cut shorter than they
	should, but this is better than failing.
*/

create procedure autoallocateentriestosub
	@subid int,
	@numberofentries int,
	@allocatorid int,
	@comments varchar(7500) = null
as
-- need to use a string since top cannot take a variable parameter
-- make sure query string has enough room for large comments
declare @AllocationsBefore int
declare @AllocationsAfter int
declare @Query nvarchar(4000)

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- calculate the number of allocations before and after
select @AllocationsBefore = count(EntryID) from AcceptedRecommendations WITH(UPDLOCK) 
	where SubEditorID = @subid and Status = 2
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- assign the next X accepted recommendations which are still unallocated
-- to the specified sub, taking them in the order in which they were accepted
set @Query = '
update AcceptedRecommendations
set	SubEditorID = @i_subid,
	AllocatorID = @i_allocatorid,
	DateAllocated = getdate(),'
if (@comments is not null) set @Query = @Query + 'Comments = @i_comments,'
set @Query = @Query + '
	Status = 2
where	Status = 1 and
		EntryID in (select top (@i_numberofentries) AR.EntryID
		from AcceptedRecommendations AR
		inner join ScoutRecommendations SR
		on SR.RecommendationID = AR.RecommendationID
		where AR.Status = 1 order by DecisionDate asc)'
--exec (@Query)

exec sp_executesql @Query,
N'@i_subid int,
@i_allocatorid int,
@i_comments varchar(7500),
@i_numberofentries int',
@i_subid = @subid,
@i_allocatorid = @allocatorid,
@i_comments = @comments,
@i_numberofentries = @numberofentries

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- ensure that all entries newly assigned to this subeditor have the correct permissions
-- do this before updating the EditorID
DELETE GuideEntryPermissions 
FROM GuideEntryPermissions gep WITH(INDEX=IX_GuideEntryPermissions)
	INNER JOIN GuideEntries g ON gep.h2g2ID=g.h2g2ID
WHERE (g.Editor IS NULL OR g.Editor != @subid) 
	AND g.EntryID IN (SELECT EntryID
					FROM AcceptedRecommendations
					WHERE SubEditorID = @subid AND Status = 2)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
	SELECT g.h2g2ID, ut.TeamID, 1, 1, 1, 1 
	FROM Users u, GuideEntries g, UserTeams ut
	WHERE u.UserId = @subid 
		AND (g.Editor IS NULL OR g.Editor != @subid) 
		AND g.EntryID IN (SELECT EntryID
					FROM AcceptedRecommendations
					WHERE SubEditorID = @subid AND Status = 2)
		AND ut.UserID = u.UserID AND ut.SiteID = g.SiteID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- now ensure that the editor id for those entries is updated to be this sub editor
update GuideEntries
set Editor = @subid
where	(Editor is null or Editor != @subid) and
		EntryID in (select EntryID
					from AcceptedRecommendations
					where SubEditorID = @subid and Status = 2)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

-- calculate the number of allocations after, then subtract the number before to get total entries allocated
select @AllocationsAfter = count(EntryID) from AcceptedRecommendations where SubEditorID = @subid and Status = 2
-- return the total number of allocations to that sub
select	'TotalAllocated' = @AllocationsAfter - @AllocationsBefore
return (0)


