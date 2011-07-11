CREATE PROCEDURE applyuserreputation @userid int, @modclassid int, @viewinguser int
-- determines and applies status to given user and mod class
AS
BEGIN

declare @currentstatus int 
declare @reputationdeterminedstatus int 
set @currentstatus = 0
set @reputationdeterminedstatus =0

exec getuserreputation @userid, @modclassid, @currentstatus output, @reputationdeterminedstatus output
-- get the current status

if @currentstatus <> @reputationdeterminedstatus
BEGIN

	exec updatetrackedmemberformodclass @userid, 
	@modclassid, -- 0 means update for all sites 
	@reputationdeterminedstatus, 
	0,
	'User determined reputation',
	@viewinguser


END

END