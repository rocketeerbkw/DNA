CREATE PROCEDURE updatetrackedmemberformodclass
	@userid int, 
	@siteids VARCHAR(8000), 
	@prefstatus INT, 
	@prefstatusduration INT,
	@reason nvarchar(max),
	@viewinguser int
AS
BEGIN

begin transaction

SELECT * INTO #usersiteid
FROM udf_splitint(@siteids)


	
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
	usids.element as 'SiteId',
	@userid as 'UserId',
	preferences.prefstatus as 'PreviousPrefStatus',
	@prefstatus as 'NewPrefStatus',
	@prefstatusduration as 'PrefDuration'
FROM #usersiteid usids
inner join preferences on preferences.userid = @userid AND preferences.siteid = usids.element

--update preference table with new preferences
UPDATE preferences
SET PrefStatus = @prefstatus,
	PrefStatusduration = @prefstatusduration,
	PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
FROM #usersiteid usids
WHERE preferences.userid = @userid AND preferences.siteid = usids.element

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

