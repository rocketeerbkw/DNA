CREATE PROCEDURE updatetrackedmemberlist 
	@userids VARCHAR(8000), 
	@siteids VARCHAR(8000), 
	@prefstatus INT, 
	@prefstatusduration INT,
	@reason nvarchar(max),
	@viewinguser int
AS
BEGIN

SELECT * INTO #usersiteidpairs 
FROM udf_getusersiteidpairs(@userids, @siteids)

BEGIN TRANSACTION

BEGIN TRY
	
	--create entry in audit table
	insert into UserPrefStatusAudit
	(UserId, Reason, DeactivateAccount, HideContent)
	values
	(@viewinguser, @reason, 0, 0)

	declare @auditId int
	select @auditId = max(UserUpdateId) from UserPrefStatusAudit
	
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

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	RETURN ERROR_NUMBER()
END CATCH
	

	
END