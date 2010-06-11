/*
	Fetches the moderation history and other associated data for a particular entry
*/

create procedure fetchpostmoderationhistory @postid int
as
set transaction isolation level read uncommitted
select TM.*, 
	TM.NewPost as NewItem, 
	TE.Subject, 
	IP.IPAddress, 
	IP.BBCUID,
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
	U2.Status as LockedByStatus, 
	U2.TaxonomyNode as LockedByTaxonomyNode,
	U3.UserId as ReferredByUserId, 
	U3.UserName as ReferredByUserName, 
	U3.FirstNames as ReferredByFirstNames, 
	U3.LastName as ReferredByLastName, 
	U3.Status as ReferredByStatus, 
	U3.TaxonomyNode as ReferredByTaxonomyNode,
	U4.UserId as ComplainantUserId, 
	U4.UserName as ComplainantUserName, 
	U4.FirstNames as ComplainantFirstNames, 
	U4.LastName as ComplainantLastName, 
	U4.Status as ComplainantStatus, 
	U4.TaxonomyNode as ComplainantTaxonomyNode, 
	U4.Email as ComplainantEmail
from ThreadMod TM
inner join ThreadEntries TE on TE.EntryID = TM.PostID
inner join Users U1 on U1.UserID = TE.UserID
left join ThreadModIPAddress ip ON ip.ThreadModId = TM.ModiD
left outer join Users U2 on U2.UserID = TM.LockedBy
left outer join Users U3 on U3.UserID = TM.ReferredBy
left outer join Users U4 on U4.UserID = TM.ComplainantID
where TE.EntryID = @postid
order by DateQueued asc, ModID asc
