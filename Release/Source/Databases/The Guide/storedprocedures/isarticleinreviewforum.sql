CREATE PROCEDURE isarticleinreviewforum @h2g2id int, @siteid int
AS

SELECT r.ReviewForumID FROM reviewforummembers r inner join reviewforums f ON r.ReviewForumID = f.ReviewForumId
where r.H2G2ID = @h2g2id AND f.SiteID = @siteid
 
return(0)
