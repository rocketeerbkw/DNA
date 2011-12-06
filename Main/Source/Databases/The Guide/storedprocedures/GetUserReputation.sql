CREATE PROCEDURE getuserreputation @userid int, @modclassid int, @currentstatus int output, @reputationdeterminedstatus int output
	
AS
BEGIN

-- get the current status

if exists(select * from users where userid=@userid and status=0)
BEGIN

	set @currentStatus = 5 --deactivated

END
ELSE
BEGIN

	select @currentStatus = min(prefstatus) -- potentially mixed values
	from preferences p
	inner join mastheads m on m.userid=p.userid and m.siteid=p.siteid -- see comment below *
	where p.userid=@userid

	-- * only consider preferences that have a matching Masthead record
	-- This ensures that the statuses that it considers match the ones displayed
	-- in the MemberDetails page.  This fixed a bug Pete found with user 14902551
	-- where the user was showing a status of "Standard", yet was premodded on all sites
	-- the user was active on

END



--get the reputation based status
select 
@reputationDeterminedStatus = 
case when urs.accumulativescore >= urt.trustedscore then 6 else -- trusted
	case when urs.accumulativescore < urt.trustedscore and urs.accumulativescore >= urt.normalscore then 0 else --standard
		case when urs.accumulativescore < urt.normalscore and urs.accumulativescore >= urt.premodscore then 2 else --post mod score
			case when urs.accumulativescore < urt.premodscore and urs.accumulativescore >= urt.bannedscore then 1 else --premod score
				case when urs.accumulativescore < urt.bannedscore  then 4 else 0 end -- banned
			end
		end
	end
end
from dbo.userreputationscore urs 
inner join dbo.userreputationthreshold urt on urt.modclassid = urs.modclassid
where urs.userid=@userid and urs.modclassid=1 --@modclassid
	
--return everyhing
select 
	@currentStatus as currentstatus,
	@reputationDeterminedStatus as reputationDeterminedStatus,
	urs.accumulativescore,
	urs.lastupdated,
	u.username
from dbo.userreputationscore urs 
inner join dbo.userreputationthreshold urt on urt.modclassid = urs.modclassid
inner join users u on u.userid = urs.userid
where urs.userid=@userid and urs.modclassid=1 --@modclassid
	 
END