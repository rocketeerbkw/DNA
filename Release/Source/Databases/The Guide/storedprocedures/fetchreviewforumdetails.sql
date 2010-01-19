CREATE PROCEDURE fetchreviewforumdetails @reviewforumid int = null, @h2g2id int = null
AS

SELECT * from ReviewForums r where (r.reviewforumid = @reviewforumid) or (r.h2g2id = @h2g2id)
return(0)
