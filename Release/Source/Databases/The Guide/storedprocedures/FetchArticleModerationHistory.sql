/*
	Fetches the moderation history and other associated data for a particular entry
*/

create procedure fetcharticlemoderationhistory @h2g2id int
as

EXEC openemailaddresskey

select AM.*, 
	AM.NewArticle as NewItem, 
	G.Subject, 
	ip.IPAddress, 
	ip.BBCUID,
	U1.UserId as AuthorUserid, 
	U1.UserName as AuthorUserName, 
	U1.FirstNames as AuthorFirstNames, 
	U1.LastName as AuthorLastName, 
	U1.TaxonomyNode  as AuthorTaxonomyNode,
	case when P1.PrefStatus is null then 0 else P1.PrefStatus end as AuthorStatus,
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
	dbo.udf_decryptemailaddress(U4.EncryptedEmail,U4.UserId) as ComplainantEmail, 
	case when P4.PrefStatus is null then 0 else P4.PrefStatus end  as ComplainantStatus, 
	U4.TaxonomyNode as complainanttaxonomynode
from ArticleMod AM
right outer join GuideEntries G on G.h2g2ID = AM.h2g2ID
left join ArticleModIPAddress ip on ip.ArticleModId = AM.ModId
inner join Users U1 on U1.UserID = G.Editor
left join preferences P1 on U1.UserID = P1.UserID and AM.siteid=P1.siteid
left outer join Users U2 on U2.UserID = AM.LockedBy
left outer join Users U3 on U3.UserID = AM.ReferredBy
left outer join Users U4 on U4.UserID = AM.ComplainantID
left join preferences P4 on U4.UserID = P4.UserID and AM.siteid=P4.siteid
where G.h2g2ID = @h2g2id
order by DateQueued asc, ModID asc
