  
CREATE PROCEDURE gettermsbyforumid @forumid int  
AS  
  
select   
 t.id as termId,  
 t.term as term,  
 tf.forumid as forumId,  
 tf.actionid as actionId  
from   
 TermsLookup t   
 inner join TermsByForum tf on tf.termid = t.id  
where  
 tf.forumid = @forumid  
order by t.term asc  
 