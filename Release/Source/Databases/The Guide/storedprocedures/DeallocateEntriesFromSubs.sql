/*
	Deallocates up to 50 entries from whichever subeditor they are allocated to, unless
	they have already been returned.
	Also returns fields showing the status of those entries in the AcceptedRecommendations
	table after the update is done, which can then be scrutinised to check if the update
	was successful.
*/

CREATE PROCEDURE  deallocateentriesfromsubs
	@deallocatorid INT,
	@id0 INT = NULL,
	@id1 INT = NULL,
	@id2 INT = NULL,
	@id3 INT = NULL,
	@id4 INT = NULL,
	@id5 INT = NULL,
	@id6 INT = NULL,
	@id7 INT = NULL,
	@id8 INT = NULL,
	@id9 INT = NULL,
	@id10 INT = NULL,
	@id11 INT = NULL,
	@id12 INT = NULL,
	@id13 INT = NULL,
	@id14 INT = NULL,
	@id15 INT = NULL,
	@id16 INT = NULL,
	@id17 INT = NULL,
	@id18 INT = NULL,
	@id19 INT = NULL,
	@id20 INT = NULL,
	@id21 INT = NULL,
	@id22 INT = NULL,
	@id23 INT = NULL,
	@id24 INT = NULL,
	@id25 INT = NULL,
	@id26 INT = NULL,
	@id27 INT = NULL,
	@id28 INT = NULL,
	@id29 INT = NULL,
	@id30 INT = NULL,
	@id31 INT = NULL,
	@id32 INT = NULL,
	@id33 INT = NULL,
	@id34 INT = NULL,
	@id35 INT = NULL,
	@id36 INT = NULL,
	@id37 INT = NULL,
	@id38 INT = NULL,
	@id39 INT = NULL,
	@id40 INT = NULL,
	@id41 INT = NULL,
	@id42 INT = NULL,
	@id43 INT = NULL,
	@id44 INT = NULL,
	@id45 INT = NULL,
	@id46 INT = NULL,
	@id47 INT = NULL,
	@id48 INT = NULL,
	@id49 INT = NULL,
	@currentsiteid INT = 0  
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- now update the AcceptedRecommendations table for each entry if it has a status of 2
	UPDATE AcceptedRecommendations
	SET SubEditorID = NULL, AllocatorID = @DeallocatorID, DateAllocated = GETDATE(), 	NotificationSent = 0, Status = 1
	WHERE Status = 2 AND EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
										@id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
										@id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
										@id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
										@id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)
	
	--check for errors
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- make sure the editor of the deallocated entries is also changed to be that
	-- of the person doing the deallocation
	EXEC @ErrorCode = ChangeEditorOnMultipleArticles @DeallocatorID, @id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
																		@id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
																		@id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
																		@id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
																		@id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49
																		
	--check for errors
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	-- extract the current sub editor, date allocated, and status of the entries
	-- so that these fields can be examined by the caller to check the success
	-- if necessary
	SELECT 
				AR.EntryID, 
				G.h2g2ID, 
				G.Subject, 
				AR.SubEditorID, 
				AR.DateAllocated, 
				AR.DateReturned, 
				AR.Status,				
				U.Username, 
				U.FirstNames,
				U.LastName,
				U.Area,
				U.Status as "UserStatus",
				U.TaxonomyNode,
				'Journal' = J.ForumID,
				U.Active,
				P.SiteSuffix,
				P.Title
	FROM AcceptedRecommendations AS AR
	INNER JOIN GuideEntries G ON G.EntryID = AR.EntryID
	LEFT OUTER JOIN Users U ON U.UserID = AR.SubEditorID
	LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) and (P.SiteID = @currentsiteid)
	INNER JOIN Journals J ON J.UserID = U.UserID and J.SiteID = @currentsiteid
	WHERE AR.EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
							@id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
							@id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
							@id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
							@id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)


	RETURN (0)
END
