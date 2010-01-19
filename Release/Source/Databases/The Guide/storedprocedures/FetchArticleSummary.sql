/*
	Fetches a summary of the article, including information about whether
	it has been accepted as a recommendation for the edited guide, or is
	itself the sub editors copy of an accepted recommendation.
*/

create procedure fetcharticlesummary @entryid int
as

declare @scoutuserid int, @scoutusername varchar(255)

SELECT TOP 1 @scoutuserid = u.UserID, @scoutusername = u.UserName
FROM ScoutRecommendations s INNER JOIN Users u ON s.ScoutID = u.UserID
WHERE EntryID = @entryid AND s.Status = 1

select	G.EntryID,
		G.h2g2ID,
		G.Subject,
		'EditorID' = G.Editor,
		'EditorName' = U.Username,
		G.Status,
		'IsSubCopy' = case isnull(AR1.EntryID, 0) when 0 then 0 else 1 end,
		'OriginalEntryID' = AR1.OriginalEntryID,
		'HasSubCopy' = case isnull(AR2.EntryID, 0) when 0 then 0 else 1 end,
		'SubCopyID' = AR2.EntryID,
		'RecommendationStatus' = isnull(AR2.Status, AR1.Status),
		'RecommendedByScoutID' = CASE WHEN @scoutuserid IS NULL THEN 0 ELSE @scoutuserid END,
		'RecommendedByUserName' = @scoutusername,
		'Comments' =	case isnull(AR1.EntryID, 0)
							when 0 then AR2.Comments
							else AR1.Comments
						end
from GuideEntries G
inner join Users U on U.UserID = G.Editor
left outer join AcceptedRecommendations AR1 on AR1.EntryID = G.EntryID
left outer join AcceptedRecommendations AR2 on AR2.OriginalEntryID = G.EntryID
where G.EntryID = @entryid
return (0)
