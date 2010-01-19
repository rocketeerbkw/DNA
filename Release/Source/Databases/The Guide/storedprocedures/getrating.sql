CREATE PROCEDURE getrating @postid int 
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 	Id, 
		Created, 
		UserID, 
		ForumID, 
		parentUri,
		text, 
		Hidden, 
		PostStyle, 
		forumuid, 
		userJournal, 
		UserName, 
		userstatus, 
		userIsEditor, 
		lastupdated as lastupdated,
		rating as rating
FROM VRatings WHERE id = @postid