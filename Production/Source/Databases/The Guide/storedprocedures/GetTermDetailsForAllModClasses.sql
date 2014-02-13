CREATE PROCEDURE gettermdetailsforallmodclasses @termid int
AS
select 
	t.id as termId,
	t.term as term,
	tm.modclassid as modClassId,
	tm.actionid as actionId
	,TERMDETAILS.Reason
	,TERMDETAILS.UpdatedDate
	,TERMDETAILS.UserID
	,u.username
from 
	TermsLookup t 
	inner join TermsByModClass tm on tm.termid = t.id
	CROSS APPLY
	(
		SELECT
			ISNULL(notes,'') Reason,
			ISNULL(updatedate,'') UpdatedDate,
			ISNULL(userid,0) UserID
		FROM TermsUpdateHistory 
			WHERE id=
			(
				SELECT MAX(updateid)
					FROM TermsByModClassHistory
					WHERE termid=t.id
			)
	) TERMDETAILS  
	inner join users u on u.userid = TERMDETAILS.UserID
WHERE
	t.id = @termid  
order by t.term asc

/*
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[TermsByModClassHistory] ([termid])

CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[TermsByModClass] ([termid])
*/