/*
	Reactivates a deactivated account.
	Note that users status is always set to 1, so if an editor was deactivated
	then reactivated they would come back as an ordinary user.
*/

create procedure reactivateaccount @userid int, 
	@reason nvarchar(max) = 'Called from legacy ripley code',
	@viewinguser int = 6 -- default to jim the god user for c++
as


BEGIN TRANSACTION

BEGIN TRY

--update audit table
insert into UserPrefStatusAudit
(UserId, Reason, DeactivateAccount, HideContent)
values
(@viewinguser, @reason, 0, 0)
declare @auditId int
select @auditId = max(UserUpdateId) from UserPrefStatusAudit

insert into UserPrefStatusAuditActions
(UserUpdateId, SiteId, UserId, PreviousPrefStatus, NewPrefStatus, PrefDuration)
values
(@auditId, 0, @userid, 0,0,0)


update threadentries
set hidden=null
from threadentries
WHERE userid = @userid
and (hidden = 8)--content removed

insert into dbo.ForumLastUpdated
select distinct(forumid), getdate()
from threadentries
where userid = @userid

update dbo.threads
set lastupdated= getdate()
where threadid in
(
	select threadid
	from threadentries
	where userid = @userid
)

update Users set SinBin = null, Active = 1, Status = 1, DateReleased = null
where UserID = @userid
-- return a field for the number of rows updated so that success can
-- be checked if necessary
select 'RowsUpdated' = @@rowcount

EXEC addtoeventqueueinternal 'ET_USERMODERATION', @auditId, 'IT_USERAUDIT', 0, 'IT_ALL', @viewinguser

COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	RETURN ERROR_NUMBER()
END CATCH

return (0)
