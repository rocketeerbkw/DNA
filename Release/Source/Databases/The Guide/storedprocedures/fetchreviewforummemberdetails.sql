CREATE PROCEDURE fetchreviewforummemberdetails @h2g2id int
AS

SELECT * from ReviewForumMembers r where r.h2g2id = @h2g2id
return(0)