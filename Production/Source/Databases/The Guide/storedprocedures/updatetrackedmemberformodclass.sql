CREATE PROCEDURE updatetrackedmemberformodclass
	@userid int, 
	@modclassid int = 0, -- 0 means update for all sites 
	@prefstatus INT, 
	@prefstatusduration INT,
	@reason nvarchar(max),
	@viewinguser int
AS
BEGIN

begin transaction


--create entry in audit table
insert into UserPrefStatusAudit
(UserId, Reason, DeactivateAccount, HideContent)
values
(@viewinguser, @reason, 0, 0)

declare @auditId int
select @auditId = SCOPE_IDENTITY()

--add details of actions taken
insert into UserPrefStatusAuditActions
(UserUpdateId, SiteId, UserId, PreviousPrefStatus, NewPrefStatus, PrefDuration)
select @auditId as 'UserUpdateId',
	s.siteid as 'SiteId',
	@userid as 'UserId',
	p.prefstatus as 'PreviousPrefStatus',
	@prefstatus as 'NewPrefStatus',
	@prefstatusduration as 'PrefDuration'
FROM preferences p 
inner join sites s on p.siteid = s.siteid
where p.userid = @userid 
and (@modclassId = 0 or s.modclassid=@modclassId)

--update preference table with new preferences
UPDATE preferences
SET PrefStatus = @prefstatus,
	PrefStatusduration = @prefstatusduration,
	PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
FROM preferences p 
inner join sites s on p.siteid = s.siteid
where p.userid = @userid 
and (@modclassId = 0 or s.modclassid=@modclassId)

EXEC addtoeventqueueinternal 'ET_USERMODERATION', @auditId, 'IT_USERAUDIT', @prefstatus, 'IT_USERPREFSTATUS', @viewinguser

commit tran
-- banned user - add ip/bbcuids to banned list
if @prefstatus = 4
BEGIN
	
	exec addbannedusersipaddress @userid 
	
END
ELSE
BEGIN
	exec removebannedusersipaddress  @userid 
END
	

END

