/*
	Fetches the moderation history and other associated data for a particular entry
*/

create procedure fetcharticlemoderationhistory @h2g2id int
as
select AM.*, 
	AM.NewArticle as NewItem, 
	G.Subject, 
	ip.IPAddress, 
	ip.BBCUID,
	U1.UserId, 
	U1.UserName, 
	U1.FirstNames,
	U1.LastName, 
	U1.Status, 
	U1.TaxonomyNode,
	U2.UserId as LockedByUserId, 
	U2.UserName as LockedByUserName, 
	U2.FirstNames as LockedByFirstNames, 
	U2.LastName as LockedByLastName,
	U2.Status as lockedbystatus, 
	U2.TaxonomyNode as lockedbytaxonomynode,
	U3.UserId as ReferredByUserId, 
	U3.UserName as ReferredByUserName, 
	U3.FirstNames as ReferredByFirstNames, 
	U3.LastName as ReferredByLastName,
	U3.Status as referredbystatus, 
	U3.TaxonomyNode as referredbytaxonomynode,
	U4.UserId as ComplainantUserId, 
	U4.UserName as ComplainantUserName, 
	U4.FirstNames as ComplainantFirstNames, 
	U4.Lastname as ComplainantLastName, 
	U4.Email as ComplainantEmail, 
	U4.Status as complainantstatus, 
	U4.TaxonomyNode as complainanttaxonomynode
from ArticleMod AM
right outer join GuideEntries G on G.h2g2ID = AM.h2g2ID
left join ArticleModIPAddress ip on ip.ArticleModId = AM.ModId
inner join Users U1 on U1.UserID = G.Editor
left outer join Users U2 on U2.UserID = AM.LockedBy
left outer join Users U3 on U3.UserID = AM.ReferredBy
left outer join Users U4 on U4.UserID = AM.ComplainantID
where G.h2g2ID = @h2g2id
order by DateQueued asc, ModID asc
