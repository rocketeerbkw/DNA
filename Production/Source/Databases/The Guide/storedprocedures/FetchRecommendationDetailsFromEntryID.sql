/*
	Fetches all the necessary details about a particular scout recommendation
	from the entry id that it recommends.
*/

create procedure fetchrecommendationdetailsfromentryid @entryid int
as
select	RecommendationID,
		SR.EntryID,
		h2g2ID,
		Subject,
		ScoutID,
		'ScoutName'			= U.Username,
		'ScoutEmail'		= U.Email,
		'ScoutFirstNames'	= U.FirstNames,
		'ScoutLastName'		= U.LastName,
		'ScoutTaxonomyNode'	= U.TaxonomyNode,
		'ScoutArea'			= U.Area,
		'ScoutStatus'		= U.Status,
		'ScoutJournal'		= J1.ForumID,
		'ScoutActive'		= U.Active,
		'ScoutTitle'		= P.Title,
		'ScoutSiteSuffix'	= P.SiteSuffix,
		'EditorID'			= Editor,
		'EditorName'		= U2.UserName,
		'EditorFirstNames'	= U2.FirstNames,
		'EditorLastName'	= U2.LastName,
		'EditorTaxonomyNode'= U2.TaxonomyNode,
		'EditorArea'		= U2.Area,
		'EditorStatus'		= U2.Status,
		'EditorJournal'		= J2.ForumID,
		'EditorActive'		= U2.Active,
		'EditorTitle'		= P2.Title,
		'EditorSiteSuffix'	= P2.SiteSuffix,
		Comments,
		DateRecommended,
		SR.Status,
		'Success' = 1
from ScoutRecommendations SR
inner join GuideEntries G on G.EntryID = SR.EntryID
inner join Users U on U.UserID = SR.ScoutID
left join Preferences P on P.UserID = U.UserID AND P.SiteID = G.SiteID
inner join Users U2 on U2.UserID = Editor
left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = G.SiteID
inner join Journals J1 on J1.UserID = U.UserID and J1.SiteID = G.SiteID
inner join Journals J2 on J2.UserID = U2.UserID and J2.SiteID = G.SiteID
where SR.EntryID = @entryid
return (0)
