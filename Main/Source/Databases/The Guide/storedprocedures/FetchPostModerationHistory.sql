/*
	Fetches the moderation history and other associated data for a particular entry
*/

create procedure fetchpostmoderationhistory @postid int
as
set transaction isolation level read uncommitted

EXEC openemailaddresskey

declare @rows int

select @rows = count(*)
from ThreadMod TM
inner join threadmodhistory tmh on tm.modid = tmh.modid
inner join ThreadEntries TE on TE.EntryID = TM.PostID
where TE.EntryID = @postid

-- test to see if the modid has a history recorded or was it prehistory
if @rows > 0
BEGIN
	select tmh.*, 
	tm.forumid,
	tm.threadid,
	tm.postid,
	tmh.eventdate as 'datequeued',
	tmh.eventdate as 'datelocked',
	case when tmh.status=2 then tmh.eventdate else null end as 'datereferred',
	tmh.eventdate as 'datecompleted',
	tm.newpost,
	tm.complainantid,
	dbo.udf_decryptemailaddress(tm.EncryptedCorrespondenceEmail,tm.modid) as CorrespondenceEmail, 
	tm.complainttext,
	tm.siteid,
	tm.ispremodposting,
	TM.NewPost as NewItem, 
	TE.Subject, 
	IP.IPAddress, 
	IP.BBCUID,
	U1.UserId as AuthorUserid, 
	U1.UserName as AuthorUserName, 
	U1.FirstNames as AuthorFirstNames, 
	U1.LastName as AuthorLastName, 
	U1.TaxonomyNode  as AuthorTaxonomyNode,
	case when P1.PrefStatus is null then 0 else P1.PrefStatus end  as AuthorStatus,
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
	case when P4.PrefStatus is null then 0 else P4.PrefStatus end as ComplainantStatus, 
	U4.TaxonomyNode as ComplainantTaxonomyNode, 
	dbo.udf_decryptemailaddress(U4.EncryptedEmail,U4.UserId) as ComplainantEmail
from ThreadMod TM
inner join threadmodhistory tmh on tm.modid = tmh.modid
inner join ThreadEntries TE on TE.EntryID = TM.PostID
inner join Users U1 on U1.UserID = TE.UserID
left join preferences P1 on U1.UserID = P1.UserID and TM.siteid=P1.siteid
left join ThreadModIPAddress ip ON ip.ThreadModId = TM.ModiD
left outer join Users U2 on U2.UserID = TMH.LockedBy
left outer join Users U3 on U3.UserID = TMH.ReferredBy and tmh.status=2 -- only show for refferred items
left outer join Users U4 on U4.UserID = TM.ComplainantID
left join preferences P4 on U4.UserID = P4.UserID and TM.siteid=P4.siteid
where TE.EntryID = @postid
order by ModID asc, eventdate asc

END
ELSE
BEGIN


	select TM.*, 
		TM.NewPost as NewItem, 
		TE.Subject, 
		IP.IPAddress, 
		IP.BBCUID,
		U1.UserId as AuthorUserid, 
		U1.UserName as AuthorUserName, 
		U1.FirstNames as AuthorFirstNames, 
		U1.LastName as AuthorLastName, 
		U1.TaxonomyNode  as AuthorTaxonomyNode,
		case when P1.PrefStatus is null then 0 else P1.PrefStatus end  as AuthorStatus,
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
		case when P4.PrefStatus is null then 0 else P4.PrefStatus end as ComplainantStatus, 
		U4.TaxonomyNode as ComplainantTaxonomyNode, 
		dbo.udf_decryptemailaddress(U4.EncryptedEmail,U4.UserId) as ComplainantEmail, 
		0 as ReasonId
	from ThreadMod TM
	inner join ThreadEntries TE on TE.EntryID = TM.PostID
	inner join Users U1 on U1.UserID = TE.UserID
	left join preferences P1 on U1.UserID = P1.UserID and TM.siteid=P1.siteid
	left join ThreadModIPAddress ip ON ip.ThreadModId = TM.ModiD
	left outer join Users U2 on U2.UserID = TM.LockedBy
	left outer join Users U3 on U3.UserID = TM.ReferredBy
	left outer join Users U4 on U4.UserID = TM.ComplainantID
	left join preferences P4 on U4.UserID = P4.UserID and TM.siteid=P4.siteid
	where TE.EntryID = @postid
	order by ModID asc, DateQueued asc

END