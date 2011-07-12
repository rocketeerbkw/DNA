/*
	Fetches all the necessary details about a particular scout recommendation.
*/

create procedure fetchrecommendationdetails @recommendationid int
as

EXEC openemailaddresskey

select	RecommendationID,
		SR.EntryID,
		h2g2ID,
		Subject,
		ScoutID,
		U1.Username		as ScoutName,
		dbo.udf_decryptemailaddress(U1.EncryptedEmail,U1.UserId) as ScoutEmail,
		U1.FirstNames	as ScoutFirstNames,
		U1.LastName		as ScoutLastName,
		U1.Area			as ScoutArea,
		U1.Status		as ScoutStatus,
		U1.TaxonomyNode	as ScoutTaxonomyNode,
		J1.ForumID		as ScoutJournal,
		U1.Active		as ScoutActive,
		P1.Title		as ScoutTitle,
		P1.SiteSuffix	as ScoutSiteSuffix,
		Editor			as EditorID,
		U2.Username		as EditorName,
		dbo.udf_decryptemailaddress(U2.EncryptedEmail,U2.UserId) as EditorEmail,
		U2.FirstNames	as EditorFirstNames,
		U2.LastName		as EditorLastName,
		U2.Area			as EditorArea,
		U2.Status		as EditorStatus,
		U2.TaxonomyNode	as EditorTaxonomyNode,
		J2.ForumID		as EditorJournal,
		U2.Active		as EditorActive,
		P2.Title		as EditorTitle,
		P2.SiteSuffix	as EditorSiteSuffix,
		Comments,
		DateRecommended,
		SR.Status
from ScoutRecommendations SR
inner join GuideEntries G on G.EntryID = SR.EntryID
inner join Users U1 on U1.UserID = SR.ScoutID
left join Preferences P1 on P1.UserID = U1.UserID AND P1.SiteID = G.SiteID
inner join Users U2 on U2.UserID = G.Editor
left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = G.SiteID
INNER JOIN Journals J1 on J1.UserID = U1.UserID and J1.SiteID = G.SiteID
INNER JOIN Journals J2 on J2.UserID = U2.UserID and J2.SiteID = G.SiteID
where SR.RecommendationID = @recommendationid
return (0)
