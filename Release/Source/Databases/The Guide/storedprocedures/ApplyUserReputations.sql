CREATE PROCEDURE applyuserreputations @modclassid int=0, @modstatus int=-10, @itemstoprocess int=0, @days int =1,
	@viewinguser int
--determines and applies status updates to all changes with certain time period	
AS
BEGIN

	set nocount on

	if @itemsToProcess =0
	BEGIN
		set @itemsToProcess = 10000
	END
	
	DECLARE @tempResults TABLE
	(
		totalitems int,
		n int,
		userid int,
		modclassid int,
		reputationDeterminedStatus int,
		currentStatus int,
		accumulativescore smallint,
		lastupdated datetime
		
		unique(userid,modclassid)
	)

	insert into @tempResults
	exec getuserreputationlist @modclassid, @modstatus, 0, @itemsToProcess, @days

	DECLARE rt_cursor CURSOR FAST_FORWARD
	FOR
	select * from @tempResults
	-- get the current status

	declare @n int
	declare @itemmodclassid int
	declare @userid int
	declare @reputationDeterminedStatus int
	declare @currentStatus int
	declare @accumulativescore smallint
	declare @lastupdated datetime
	declare @totalitems int
	 
	OPEN rt_cursor
	 
	FETCH NEXT FROM rt_cursor INTO @totalitems, @n, @itemmodclassid , @userid, @reputationDeterminedStatus, @currentStatus, @accumulativescore, @lastupdated

	WHILE @@FETCH_STATUS = 0
	BEGIN
		print 'Updating userid ' + convert(varchar(20), @userid)
		
		exec updatetrackedmemberformodclass
		@userid, 
		@itemmodclassid, -- 0 means update for all sites 
		@reputationDeterminedStatus, 
		0,
		'User determined reputation',
		@viewinguser
		
		FETCH NEXT FROM rt_cursor INTO @totalitems, @n, @itemmodclassid , @userid, @reputationDeterminedStatus, @currentStatus, @accumulativescore, @lastupdated
	END
	
	CLOSE rt_cursor
	DEALLOCATE rt_cursor
	
END