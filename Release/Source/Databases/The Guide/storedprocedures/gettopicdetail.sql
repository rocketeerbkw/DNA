CREATE PROCEDURE gettopicdetail @itopicid INT
AS
BEGIN	

	--get the corresponding guideentries and topics table record
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
	
	SELECT tp.TopicID, ge.h2g2ID, ge.SiteID, ge.ForumID, tp.TopicStatus, ge.Subject AS "TITLE" , 
				ge.text AS "DESCRIPTION", tp.[Position], tp.TopicLinkID, tp.CreatedDate, tp.EditKey,
				tp.LastUpdated, 'CreatedByUserName' = us1.username, 'CreatedByUserID' = us1.UserID,
				'UpdatedByUserName' = us2.username, 'UpdatedByUserID' = us2.UserID, ge.Style,
				'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID),
				"FP_ElementID" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN te.topicelementid 
						WHEN fp.ElementStatus = 1 THEN te.topicelementid 
						ELSE 0 
					END, 				
				"FP_ElementStatus" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN fp.ElementStatus 
						WHEN fp.ElementStatus = 1 THEN fp.ElementStatus 
						ELSE NULL 
					END, 					
				"FP_Template" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN fp.templatetype 
						WHEN fp.ElementStatus = 1 THEN fp.templatetype 
						ELSE NULL 
					END, 
				"FP_Position" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN fp.frontpageposition 
						WHEN fp.ElementStatus = 1 THEN fp.frontpageposition 
						ELSE NULL 
					END, 
				"FP_Title" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN fp.title 
						WHEN fp.ElementStatus = 1 THEN fp.title 
						ELSE NULL 
					END , 
				"FP_EditKey" =
					CASE 
						WHEN fp.ElementStatus = 0 THEN fp.EditKey 
						WHEN fp.ElementStatus = 1 THEN fp.EditKey 
						ELSE NULL 
					END 				
	FROM dbo.Topics tp 
		INNER JOIN dbo.GuideEntries ge ON tp.h2g2ID = ge.h2g2ID
		LEFT JOIN dbo.Forums f ON f.ForumID = ge.ForumID
		LEFT JOIN dbo.Users us1 ON tp.UserCreated = us1.userid 
		LEFT JOIN dbo.Users us2 ON tp.UserUpdated = us2.userid 
		LEFT JOIN dbo.TopicElements te ON te.TopicID = tp.TopicID
		LEFT JOIN dbo.FrontPageElements fp ON fp.ElementID = te.ElementID
	WHERE tp.TopicID = @itopicid 
END
