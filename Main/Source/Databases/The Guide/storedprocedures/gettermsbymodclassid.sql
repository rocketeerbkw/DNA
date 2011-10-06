CREATE PROCEDURE gettermsbymodclassid @modclassid int
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
	CROSS APPLY (SELECT ISNULL(notes,'') Reason, ISNULL(updatedate,'') UpdatedDate,ISNULL(userid,0) UserID FROM TermsUpdateHistory 
					WHERE id=(SELECT MAX(updateid) FROM TermsByModClassHistory WHERE termid=t.id AND modclassid = @modclassid)) TERMDETAILS  
	inner join users u on u.userid = TERMDETAILS.UserID
WHERE  
   TM.modclassid = @modclassid  
order by t.term asc
