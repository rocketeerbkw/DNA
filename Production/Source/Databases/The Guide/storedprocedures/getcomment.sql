CREATE PROCEDURE getcomment @postid int 
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 	Id, 
		Created, 
		UserID, 
		vc.ForumID, 
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
		SiteSpecificDisplayName,
		IsEditorPick,
		PostIndex,
		case when crv.value is null then 0 else crv.value end as nerovalue,
		case when crv.positivevalue is null then 0 else crv.positivevalue end as neropositivevalue,
		case when crv.negativevalue is null then 0 else crv.negativevalue end as neronegativevalue,
		TweetId
	FROM VComments vc
	left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = vc.id
	WHERE id = @postid