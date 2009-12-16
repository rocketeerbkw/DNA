CREATE PROCEDURE updatetrackedmemberlist 
	@userids VARCHAR(8000), 
	@siteids VARCHAR(8000), 
	@prefstatus INT, 
	@prefstatusduration INT
AS
BEGIN
	SELECT * INTO #usersiteidpairs 
	FROM udf_getusersiteidpairs(@userids, @siteids)

	UPDATE preferences
	SET PrefStatus = @prefstatus,
		PrefStatusduration = @prefstatusduration,
		PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
	FROM #usersiteidpairs usids
	WHERE preferences.userid = usids.userid AND preferences.siteid = usids.siteid
	
	DROP TABLE #usersiteidpairs
END