CREATE PROCEDURE getuserreputationlist @modclassid int =0, @modstatus int =-10, @startindex int =0, @itemsperpage int =20,
										@days int =1
	
AS
BEGIN

declare @startdate datetime
set @startdate = dateadd(dd, @days *-1, getdate())


;with cte_usersstatus as
(
	select row_number() over ( order by rds.lastupdated desc) as n, rds.modclassid,rds.userid,
		rds.reputationDeterminedStatus, cs.currentStatus, rds.accumulativescore,rds.lastupdated
	from 
	(
		select urs.userid, urs.modclassid, urs.accumulativescore,urs.lastupdated, 
		case when urs.accumulativescore >= urt.normalscore then 0 else -- standard
			case when urs.accumulativescore < urt.normalscore and urs.accumulativescore >= urt.premodscore then 2 else --post mod score
				case when urs.accumulativescore < urt.premodscore and urs.accumulativescore >= urt.bannedscore then 1 else --premod score
					case when urs.accumulativescore < urt.bannedscore  then 4 else 0 end -- banned
				end
			end
		end as reputationDeterminedStatus
		from dbo.userreputationscore urs 
		inner join dbo.userreputationthreshold urt on urt.modclassid = urs.modclassid
		where (@modclassid = 0 or urs.modclassid = @modclassid)
		and urs.lastupdated > @startdate
	) rds
	inner join
	(
		select min(prefstatus) as currentStatus, s.modclassid, p.userid
		from preferences p
		inner join sites s on s.siteid=p.siteid 
		where (@modclassid = 0 or s.modclassid = @modclassid)
		group by s.modclassid, p.userid

		
	) cs on cs.modclassid = rds.modclassid and cs.userid = rds.userid
	where 
		rds.reputationDeterminedStatus <> cs.currentStatus
		and (@modstatus =-10 or rds.reputationDeterminedStatus = @modstatus)
),
CTE_TOTAL AS
(
	SELECT (SELECT CAST(MAX(n) AS INT) FROM cte_usersstatus) AS 'total', * FROM cte_usersstatus
)
select *
from CTE_TOTAL
where 
	n > @startindex and n <= @startindex + @itemsperpage
	
	 
END