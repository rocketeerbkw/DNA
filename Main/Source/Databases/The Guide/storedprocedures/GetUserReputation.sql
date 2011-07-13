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
	inner join sites s on s.siteid=p.siteid and s.modclassid=@modclassid
	where p.userid=@userid


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
where urs.userid=@userid and urs.modclassid=@modclassid
	
--return everyhing
select 
	@currentStatus as currentstatus,
	@reputationDeterminedStatus as reputationDeterminedStatus,
	urs.accumulativescore,
	urs.lastupdated
from dbo.userreputationscore urs 
inner join dbo.userreputationthreshold urt on urt.modclassid = urs.modclassid
where urs.userid=@userid and urs.modclassid=@modclassid
	 
END