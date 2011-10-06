  
CREATE PROCEDURE gettermsbyforumid @forumid int  
AS  
  
select   
 t.id as termId,  
 t.term as term,  
 tf.forumid as forumId,  
 tf.actionid as actionId  
 ,TERMDETAILS.Reason
	,TERMDETAILS.UpdatedDate
	,TERMDETAILS.UserID
	,u.username
from   
 TermsLookup t   
 inner join TermsByForum tf on tf.termid = t.id  
 CROSS APPLY (SELECT ISNULL(notes,'') Reason, ISNULL(updatedate,'') UpdatedDate,ISNULL(userid,0) UserID FROM TermsUpdateHistory 
					WHERE id=(SELECT MAX(updateid) FROM TermsByForumHistory WHERE termid=t.id AND forumid = @forumid)) TERMDETAILS  
	inner join users u on u.userid = TERMDETAILS.UserID
where  
 tf.forumid = @forumid  
order by t.term asc  
 