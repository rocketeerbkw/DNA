/*
	Fetches details on all the allocations for this sub which they have
	not yet been notified of and have status 'Allocated', and then updates
	the notification status of those entries and the subs notified date.
*/

CREATE PROCEDURE fetchandupdatesubsunnotifiedallocations @subid INT, @currentsiteid INT = 0  
AS
BEGIN

	EXEC openemailaddresskey

	-- first select all the necessary fields
	SELECT	
			RecommendationID,
			SubEditorID,
			'SubName' = U.Username,
			'SubEmail' = dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserID),
			AR.EntryID,
			G.h2g2ID,
			G.Subject,
			'EditorID' = G.Editor,
			'EditorName' = (SELECT Username FROM Users WHERE UserID = G.Editor),
			'AuthorID' = G2.Editor,
			'AuthorName' = U2.Username,
			DateAllocated,
			U.FIRSTNAMES,
			U.LASTNAME,
			U.AREA,
			U.STATUS,
			U.TAXONOMYNODE,
			'Journal' = J.ForumID,
			U.ACTIVE,
			P.SITESUFFIX,
			P.TITLE
	FROM AcceptedRecommendations AS AR
	INNER JOIN GuideEntries AS G ON G.EntryID = AR.EntryID
	INNER JOIN Users AS U ON U.UserID = AR.SubEditorID
	LEFT JOIN Preferences AS P WITH(NOLOCK) ON (P.UserID = U.UserID) and (P.SiteID = @currentsiteid)
	LEFT OUTER JOIN GuideEntries AS G2 ON G2.EntryID = AR.OriginalEntryID
	LEFT OUTER JOIN Users AS U2 ON U2.UserID = G2.Editor
	INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @currentsiteid
	WHERE AR.SubEditorID = @subid AND AR.NotificationSent = 0 AND AR.Status = 2

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT, @rowcount INT

	-- then update the notification status of each of the allocations
	UPDATE AcceptedRecommendations
	SET NotificationSent = 1
	WHERE SubEditorID = @subid AND NotificationSent = 0 AND Status = 2
	SELECT @rowcount = @@ROWCOUNT ,@ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- only update the sub editors last notified date if there was at least one notification
	IF (@rowcount > 0)
	BEGIN
		-- if sub has no entry in table sub details table then insert one
		IF (NOT EXISTS (SELECT * FROM SubDetails WHERE SubEditorID = @subid))
		BEGIN
			INSERT INTO SubDetails (SubEditorID) 
			VALUES (@subid)
			
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
		END
	
		-- finally update the last notified date for the sub editor
		UPDATE SubDetails 
		SET DateLastNotified = GETDATE()
		WHERE SubEditorID = @subid
		
		SELECT @ErrorCode = @@ERROR		
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

	COMMIT TRANSACTION

	RETURN (0)
	
END
