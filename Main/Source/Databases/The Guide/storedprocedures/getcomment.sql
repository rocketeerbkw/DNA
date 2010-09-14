CREATE PROCEDURE getcomment @postid int 
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
		lastupdated,
		SiteSpecificDisplayName
	FROM VComments WHERE id = @postid