CREATE PROCEDURE gettermsbymodclassid @modclassid int
AS

select 
	t.id as termId,
	t.term as term,
	tm.modclassid as modClassId,
	tm.actionid as actionId
from 
	TermsLookup t 
	inner join TermsByModClass tm on tm.termid = t.id
where
	tm.modclassid = @modclassid
order by t.term asc
