CREATE PROCEDURE profanitiesgetall
AS

select 
	tm.termid as ProfanityID,
	tl.term as Profanity,
	tm.modclassid as ModClassID,
	case when actionid = 1 then 1 else 0 end as Refer
from 
	termsbymodclass tm 
	inner join termslookup tl on tl.id = tm.termid
where
	actionid >0
ORDER BY ModClassID, Refer, Profanity ASC

--SELECT P.ProfanityID, P.Profanity, P.ModClassID, P.Refer
--FROM Profanities P
--ORDER BY P.ModClassID, P.Refer, P.Profanity ASC