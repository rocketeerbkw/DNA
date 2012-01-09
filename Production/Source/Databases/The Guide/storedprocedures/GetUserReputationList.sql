CREATE PROCEDURE getuserreputationlist @modclassid int =1, @modstatus int =-10, @startindex int =0, @itemsperpage int =20,
										@days int =1, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
	
AS
BEGIN

declare @startdate datetime
set @startdate = dateadd(dd, @days *-1, getdate())

DECLARE @reputationreport TABLE 
( 
    modclassid INT, 
    userid INT, 
    reputationDeterminedStatus int,
    currentStatus int,
    accumulativescore smallint, 
    lastupdated datetime
)

insert into @reputationreport
select rds.modclassid,rds.userid, rds.reputationDeterminedStatus, cs.currentStatus, rds.accumulativescore,rds.lastupdated
from 
(
	select urs.userid, urs.modclassid, urs.accumulativescore,urs.lastupdated, 
	case when urs.accumulativescore >= urt.trustedscore then 6 else -- trusted
		case when urs.accumulativescore < urt.trustedscore and urs.accumulativescore >= urt.normalscore then 0 else --standard
			case when urs.accumulativescore < urt.normalscore and urs.accumulativescore >= urt.premodscore then 2 else --post mod score
				case when urs.accumulativescore < urt.premodscore and urs.accumulativescore >= urt.bannedscore then 1 else --premod score
					case when urs.accumulativescore < urt.bannedscore  then 4 else 0 end -- banned
				end
			end
		end
	end as reputationDeterminedStatus
	from dbo.userreputationscore urs 
	inner join dbo.userreputationthreshold urt on urt.modclassid = urs.modclassid
	where (urs.modclassid = 1)
	and urs.lastupdated > @startdate
) rds
inner join
(
	select min(prefstatus) as currentStatus, p.userid
	from preferences p
	group by p.userid

	
) cs on cs.userid = rds.userid
where 
	rds.reputationDeterminedStatus <> cs.currentStatus
	and (@modstatus =-10 or rds.reputationDeterminedStatus = @modstatus)



;with cte_usersstatus as
(
	select row_number() over ( order by lastupdated desc) as n, modclassid,userid, reputationDeterminedStatus, currentStatus, accumulativescore,lastupdated
	from @reputationreport
	where @sortBy = 'created' and @sortDirection = 'descending'
	
	union all
	
	select row_number() over ( order by lastupdated asc) as n, modclassid,userid, reputationDeterminedStatus, currentStatus, accumulativescore,lastupdated
	from @reputationreport
	where @sortBy = 'created' and @sortDirection = 'ascending'
	
	union all
	
	select row_number() over ( order by accumulativescore asc) as n, modclassid,userid, reputationDeterminedStatus, currentStatus, accumulativescore,lastupdated
	from @reputationreport
	where @sortBy = 'reputationscore' and @sortDirection = 'ascending'
	
	union all
	
	select row_number() over ( order by accumulativescore desc) as n, modclassid,userid, reputationDeterminedStatus, currentStatus, accumulativescore,lastupdated
	from @reputationreport
	where @sortBy = 'reputationscore' and @sortDirection = 'descending'
	
	
),
CTE_TOTAL AS
(
	SELECT (SELECT CAST(MAX(n) AS INT) FROM cte_usersstatus) AS 'total', * FROM cte_usersstatus
)
select *, u.username
from CTE_TOTAL cte
inner join users u on cte.userid = u.userid
where 
	n > @startindex and n <= @startindex + @itemsperpage
	
	 
END