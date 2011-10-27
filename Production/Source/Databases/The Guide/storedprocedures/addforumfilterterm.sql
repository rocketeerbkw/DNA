  
Create Procedure addforumfilterterm @term nvarchar(50), @actionid int, @forumid int, @historyid int  
As  
  
 declare @termId int  
   
 --match existing term  
 select   
  @termId = id  
 from  
  TermsLookup  
 where  
  term = @term  
    
 if @termId is null  
 BEGIN  
  -- doesn't exist so create it..  
  insert into TermsLookup  
   (term)  
  values  
   (@term)  
    
  select @termId = @@identity   
 END  
   
 if @actionid = 0  
 BEGIN  
  delete from TermsByForum  
  where termId=@termId  
   and forumid = @forumid  
 END  
 ELSE  
 BEGIN  
  --update the action in the table  
  update TermsByForum
  set   
   actionid = @actionid  
  where  
   termid = @termId  
   and forumid = @forumid  
     
  if @@rowcount = 0  
  BEGIN-- no matches - so insert  
   insert into TermsByForum  
    (termid, forumid, actionid)  
   values  
    (@termid, @forumid, @actionid)  
  END  
 END  
 --insert into history  
 insert into TermsByForumHistory  
   (termid, forumid, actionid, updateid)  
  values  
   (@termId, @forumid, @actionid, @historyid)  
   
    

  