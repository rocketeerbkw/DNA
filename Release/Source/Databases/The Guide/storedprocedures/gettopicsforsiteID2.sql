CREATE PROCEDURE gettopicsforsiteid2 @isiteid INT, @itopicstatus INT, @includearchived INT =0
AS
BEGIN

	--get the corresponding guideentries and topics table records
	--Deleted and archived elements are not useful in the result set 
	--expected from this stored procedure hence there are marked as not
	--present by setting the relevant fields to NULL and ) as the case may be
	--the following status are supported  
	--0 = Preview element
	--1 = Live/Active element
	--2 = Deleted element
	--3 = Archived element.
	--Another way of doing may be to set the fields at the point which the record
	--is deleted or archived

	-- Check to see if we're asked to get the archived topics as well
	DECLARE @TopicStatus2 INT
	SELECT @TopicStatus2 =	CASE WHEN @includearchived <> 0 AND @iTopicStatus = 0 THEN 3
								 WHEN @includearchived <> 0 AND @iTopicStatus = 1 THEN 4
								 ELSE @iTopicStatus END
	
	SELECT tp.TopicID, ge.h2g2ID, ge.SiteID, tp.TopicStatus, ge.Subject AS "TITLE" , ge.ForumID, 
				ge.text AS "DESCRIPTION", tp.[Position], tp.TopicLinkID, tp.CreatedDate, tp.EditKey,
				tp.LastUpdated, 'CreatedByUserName' = us1.username, 'CreatedByUserID' = us1.UserID,
				'UpdatedByUserName' = us2.username, 'UpdatedByUserID' = us2.UserID, ge.Style, 'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID),
				"FP_ElementID" = 	te.TopicElementID,
				"FP_ElementStatus" = fp.ElementStatus, 					
				"FP_Template" = fp.templatetype, 
				"FP_Position" = fp.frontpageposition, 
				"FP_Title" = fp.title,
				"FP_Text" = fp.text,
				"FP_ImageName" = fp.ImageName,
				"FP_ImageAltText" = fp.ImageAltText,
				"FP_EditKey" = fp.EditKey,
				fastmod = case when fmf.forumid is null then 0 else 1 end
	FROM dbo.Topics tp WITH(NOLOCK)
		LEFT JOIN dbo.TopicElements te ON te.TopicID = tp.TopicID
		LEFT JOIN FrontPageElements fp ON fp.Elementid = te.ElementID
		LEFT JOIN dbo.GuideEntries ge ON tp.h2g2ID = ge.h2g2ID
		LEFT JOIN dbo.Forums f ON f.ForumID = ge.ForumID
		LEFT JOIN dbo.Users us1 ON tp.UserCreated = us1.userid 
		LEFT JOIN dbo.Users us2 ON tp.UserUpdated = us2.userid 
		LEFT JOIN dbo.FastModForums fmf ON fmf.ForumID = f.ForumID
	WHERE tp.SiteID = @iSiteID AND tp.TopicStatus IN (@iTopicStatus,@TopicStatus2)
	ORDER BY fp.frontpageposition ASC
END