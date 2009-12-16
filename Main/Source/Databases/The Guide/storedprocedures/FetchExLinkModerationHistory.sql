create procedure fetchexlinkmoderationhistory @url varchar(256)
as
set transaction isolation level read uncommitted
select ex.*, @url as subject,
	U2.UserId as LockedByUserId, U2.UserName as LockedByUserName, U2.FirstNames as LockedByFirstNames, U2.LastName as LockedByLastName, U2.Status as LockedByStatus, U2.TaxonomyNode as LockedByTaxonomyNode,
	U3.UserId as ReferredByUserId, U3.UserName as ReferredByUserName, U3.FirstNames as ReferredByFirstNames, U3.LastName as ReferredByLastName, U3.Status as ReferredByStatus, U3.TaxonomyNode as ReferredByTaxonomyNode
from ExLinkMod ex
left outer join Users U2 on U2.UserID = ex.LockedBy
left outer join Users U3 on U3.UserID = ex.ReferredBy
where uri = @url

order by DateQueued, ModId asc

