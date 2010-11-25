/*
	Deactivates an account without cancelling it altogether
*/

create procedure deactivateaccount @userid int,
	@hidecontent bit =0,
	@reason nvarchar(max) = 'Called from legacy ripley code',
	@viewinguser int = 6 -- default to jim the god user for c++
as

BEGIN TRANSACTION

BEGIN TRY
--update audit table
insert into UserPrefStatusAudit
(UserId, Reason, DeactivateAccount, HideContent)
values
(@viewinguser, @reason, 1, @hidecontent)
declare @auditId int
select @auditId = max(UserUpdateId) from UserPrefStatusAudit

insert into UserPrefStatusAuditActions
(UserUpdateId, SiteId, UserId, PreviousPrefStatus, NewPrefStatus, PrefDuration)
values
(@auditId, 0, @userid, 0,0,0)

--check if removing content
if @hideContent = 1
BEGIN
	update threadentries
	set hidden=8 --content removed
	from threadentries
	WHERE userid = @userid
	and (hidden is null)
	
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
	
END


--do update of user
update Users set SinBin = 1, Active = 0, Status = 0, DateReleased = getdate()
where UserID = @userid
-- return a field for the number of rows updated so that success can
-- be checked if necessary
select 'RowsUpdated' = @@rowcount

-- add event 
EXEC addtoeventqueueinternal 'ET_USERMODERATION', @auditId, 'IT_USERAUDIT', 0, 'IT_ALL', @viewinguser

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	RETURN ERROR_NUMBER()
END CATCH

return (0)
