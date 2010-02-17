/* SCRIPT TO GET OLD VALUES FOR PRESERVATION */
--select 'insert into dbo.ContentSignifIncrement values ('+CAST(ActionID AS VARCHAR(10))+','+CAST(ItemID AS VARCHAR(10))+','+CAST(SiteID AS VARCHAR(10))+','+CAST([Value] AS VARCHAR(10))+')'
--  from dbo.ContentSignifIncrement

/* OLD VALUES TO PRESERVE AND EVENTUALLY PUT BACK IN THE DATABASE - N.B. THESE VALUES ARE FROM LIVE SO DO NOT DELETE THEM!!! */
--insert into dbo.ContentSignifIncrement values (1,1,16,2)
--insert into dbo.ContentSignifIncrement values (1,3,16,5)
--insert into dbo.ContentSignifIncrement values (2,1,16,2)
--insert into dbo.ContentSignifIncrement values (2,3,16,5)
--insert into dbo.ContentSignifIncrement values (2,5,16,2)
--insert into dbo.ContentSignifIncrement values (3,1,16,2)
--insert into dbo.ContentSignifIncrement values (3,3,16,5)
--insert into dbo.ContentSignifIncrement values (3,4,16,2)
--insert into dbo.ContentSignifIncrement values (3,6,16,2)
--insert into dbo.ContentSignifIncrement values (4,1,9,10)
--insert into dbo.ContentSignifIncrement values (4,1,16,5)
--insert into dbo.ContentSignifIncrement values (4,2,9,10)
--insert into dbo.ContentSignifIncrement values (4,5,9,10)
--insert into dbo.ContentSignifIncrement values (4,5,16,5)
--insert into dbo.ContentSignifIncrement values (4,6,9,10)
--insert into dbo.ContentSignifIncrement values (5,1,16,10)
--insert into dbo.ContentSignifIncrement values (5,2,16,10)
--insert into dbo.ContentSignifIncrement values (6,1,16,10)
--insert into dbo.ContentSignifIncrement values (6,2,16,10)
--insert into dbo.ContentSignifIncrement values (6,3,16,10)
--insert into dbo.ContentSignifIncrement values (6,4,16,10)
--insert into dbo.ContentSignifIncrement values (6,5,16,10)
--insert into dbo.ContentSignifIncrement values (6,6,16,10)
--insert into dbo.ContentSignifIncrement values (6,6,63,10)
--insert into dbo.ContentSignifIncrement values (7,1,16,5)
--insert into dbo.ContentSignifIncrement values (7,2,16,10)
--insert into dbo.ContentSignifIncrement values (7,3,16,2)
--insert into dbo.ContentSignifIncrement values (8,5,16,2)
--insert into dbo.ContentSignifIncrement values (9,1,9,-10)
--insert into dbo.ContentSignifIncrement values (9,1,16,5)
--insert into dbo.ContentSignifIncrement values (9,2,9,-10)
--insert into dbo.ContentSignifIncrement values (9,5,9,-10)
--insert into dbo.ContentSignifIncrement values (9,5,16,5)
--insert into dbo.ContentSignifIncrement values (9,6,9,-10)

/* DELETE FROM DBO.CONTENTSIGNIFINCREMENT */
delete from dbo.ContentSignifIncrement
go

/* INSERT TEST VALUES */
insert into dbo.ContentSignifIncrement
select act.ActionID, itm.ItemID, s.SiteID, 10 
  from dbo.ContentSignifAction act
		CROSS JOIN dbo.ContentSignifItem itm
		CROSS JOIN dbo.Sites s

/* rename AddNoticeBoardPostToHierarchy to AddThreadToHierarchy */
update dbo.ContentSignifAction
   set ActionDesc = 'AddThreadToHierarchy'
 where ActionDesc = 'AddNoticeBoardPostToHierarchy'

