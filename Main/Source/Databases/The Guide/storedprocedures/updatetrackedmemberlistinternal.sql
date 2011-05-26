CREATE PROCEDURE updatetrackedmemberlistinternal 
	@userids VARCHAR(8000), 
	@siteids VARCHAR(8000), 
	@prefstatus INT, 
	@prefstatusduration INT,
	@reason nvarchar(max),
	@viewinguser int
AS
BEGIN

IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('riskmod_postriskmodthreadentrytoforum cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

SELECT * INTO #usersiteidpairs 
FROM udf_getusersiteidpairs(@userids, @siteids)


	
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
	usids.siteid as 'SiteId',
	usids.userid as 'UserId',
	preferences.prefstatus as 'PreviousPrefStatus',
	@prefstatus as 'NewPrefStatus',
	@prefstatusduration as 'PrefDuration'
FROM #usersiteidpairs usids
inner join preferences on preferences.userid = usids.userid AND preferences.siteid = usids.siteid

--update preference table with new preferences
UPDATE preferences
SET PrefStatus = @prefstatus,
	PrefStatusduration = @prefstatusduration,
	PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
FROM #usersiteidpairs usids
WHERE preferences.userid = usids.userid AND preferences.siteid = usids.siteid

EXEC addtoeventqueueinternal 'ET_USERMODERATION', @auditId, 'IT_USERAUDIT', @prefstatus, 'IT_USERPREFSTATUS', @viewinguser

-- banned user - add ip/bbcuids to banned list
declare @userid int
if @prefstatus = 4
BEGIN
	
	DECLARE rt_cursorUsers CURSOR
	FOR
	select distinct userid  from #usersiteidpairs
	
	OPEN rt_cursorUsers
	
	FETCH NEXT FROM rt_cursorUsers INTO @userid
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec addbannedusersipaddress @userid 
		FETCH NEXT FROM rt_cursorUsers INTO @userid
	END
	CLOSE rt_cursorUsers
	DEALLOCATE rt_cursorUsers
END
ELSE
BEGIN

	DECLARE rt_cursorUsers CURSOR
	FOR
	select distinct userid  from UserPrefStatusAuditActions where PreviousPrefStatus=4 and UserUpdateId=@auditId
	
	OPEN rt_cursorUsers
	
	FETCH NEXT FROM rt_cursorUsers INTO @userid
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec removebannedusersipaddress  @userid 
		FETCH NEXT FROM rt_cursorUsers INTO @userid
	END
	CLOSE rt_cursorUsers
	DEALLOCATE rt_cursorUsers
END

END

