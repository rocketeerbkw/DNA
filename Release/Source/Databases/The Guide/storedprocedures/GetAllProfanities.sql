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
 0 as 'ForumID',     
 cast(case when tm.actionid = 1 then 1 else 0 end as tinyint) as 'Refer'    
from    
 termsbymodclass tm    
 inner join termslookup t on t.id = tm.termid    
where    
 tm.actionid in (1,2)    

union
select     
 count(*) over() as 'Count',    
 t.id as 'ProfanityID',    
 t.term as 'Profanity',
 0 as 'ModClassID',    
 tf.forumid as 'ForumID',    
 cast(case when tf.actionid = 1 then 1 else 0 end as tinyint) as 'Refer'    
from    
 termsbyforum tf    
 inner join termslookup t on t.id = tf.termid    
where    
 tf.actionid in (1,2) 
order by    
 t.term, Refer 

--This is the old version and uses the profanities table instead of terms filter table.
--declare @count int
--SELECT @count = COUNT(*) FROM Profanities
--SELECT Count = @count, * FROM Profanities ORDER BY Profanity

