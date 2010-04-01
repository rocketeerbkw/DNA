/*
 Gets all columns in Profanities DB in alphabetical order
*/

create procedure getallprofanities 
as

select 
	count(*) over() as 'Count',
	t.id as 'ProfanityID',
	t.term as 'Profanity',
	tm.modclassID as 'ModClassID',
	cast(case when tm.actionid = 1 then 1 else 0 end as tinyint) as 'Refer'
from
	termsbymodclass tm
	inner join termslookup t on t.id = tm.termid
where
	tm.actionid in (1,2)
order by
	t.term, Refer
