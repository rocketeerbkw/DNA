/*
	copies the scout recommendation into the accepted recommendations table
	and sets the status value appropriately in each table.
*/

create procedure acceptscoutrecommendation
	@recommendationid int,
	@acceptorid int,
	@comments varchar(4000) = null
as
-- check that the id provided is a valid one first, and that this particular recommendation has not already been accepted
if (exists (select RecommendationID from ScoutRecommendations where RecommendationID = @recommendationid)
	and not exists(select RecommendationID from AcceptedRecommendations where RecommendationID = @recommendationid))
begin
	-- will need to find the entry id and will also need the ID of the copy created
	declare @OldEntryID int, @NewEntryID int

	BEGIN TRANSACTION   
	DECLARE @ErrorCode INT

	-- first update the recommendations table
	-- status 3 = 'Accepted'
	update ScoutRecommendations
		set Status = 3, DecisionDate = getdate()
		where RecommendationID = @recommendationid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	-- then get the entry id for the recommendation
	select @OldEntryID = EntryID
	from ScoutRecommendations
	where RecommendationID = @recommendationid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	-- now make a copy of the entry - this is the one which will be processed
	-- through the system from now on
	-- get the blob ID and editor ID for the original entry
	declare @OldEditor int, @Subject varchar(255)
	select @OldEditor = Editor, @Subject = Subject
	from GuideEntries WITH(UPDLOCK)
	where EntryID = @OldEntryID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	-- create a new (empty) forum for the copy of the guide entry
	declare @ForumID int
	
	-- *** type 1 forum ---
	
	insert into Forums (Title) values (@Subject)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	set @ForumID = @@IDENTITY
	-- now we can make a copy of the guide entry, changing any appropriate values
	-- note that the user doing the accepting is made the editor for the time being
	insert into GuideEntries (blobid, text, BasedOn, Editor, ForumID, Subject, Keywords, Style, Status, ExtraInfo)
		select  0, text, @OldEntryID, @acceptorid, @ForumID, Subject, Keywords, Style, 4, ExtraInfo
		from GuideEntries where EntryID = @OldEntryID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	select @NewEntryID = @@IDENTITY
	-- add the editor of the original entry as a researcher for the new entry
	insert into Researchers (EntryID, UserID)
		--values (@NewEntryID, @OldEditor)
		SELECT @NewEntryID, UserID FROM Researchers WHERE EntryID = @OldEntryID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

-- Jim, 24/7/2006
-- Removed this update code because it's superfluous. Added the ExtraInfo field into the above INSERT statement
-- rendering the UPDATETEXT code unnecessary.

--	-- copy across the extrainfo. We need to use the 
--	DECLARE @sourcetextptr varbinary(16), 
--			@targettextptr varbinary(16)
--
--	-- have to set the extrainfo to not null value for UPDATETEXT to work
--
--	update GuideEntries set ExtraInfo = ' ' where entryid = @NewEntryID
--
--	-- get the text pointers 
--	SELECT @sourcetextptr=TEXTPTR(ExtraInfo) FROM guideentries (UPDLOCK)
--	where entryid = @OldEntryID
--	SELECT @targettextptr=TEXTPTR(ExtraInfo) FROM guideentries (UPDLOCK)
--	where entryid = @NewEntryID
--
--	--overwrite the newentry extrainfo with the old one
--	if  @sourcetextptr IS NOT NULL AND @targettextptr IS NOT NULL
--	BEGIN
--		UPDATETEXT guideentries.ExtraInfo @targettextptr 0 NULL WITH LOG guideentries.ExtraInfo @sourcetextptr 
--	END
--	SELECT @ErrorCode = @@ERROR
--	IF (@ErrorCode <> 0)
--	BEGIN
--		ROLLBACK TRANSACTION
--		SELECT 'Success' = 0
--		RETURN @ErrorCode
--	END
	
	-- calculate the h2g2 ID for the new entry and set its value
	declare @temp int, @Checksum int
	select @temp = @NewEntryID, @Checksum = 0
	while @temp > 0
	begin
		select @Checksum = @Checksum + (@temp % 10)
		select @temp = @temp  / 10
	end
	select @Checksum = (10 * @NewEntryID) + (9 - @Checksum % 10)
	update GuideEntries set h2g2ID = @checksum where EntryID = @NewEntryID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END


	declare @Oldh2g2ID int
	select @temp = @OldEntryID, @Oldh2g2ID = 0
	while @temp > 0
	begin
		select @Oldh2g2ID = @Oldh2g2ID + (@temp % 10)
		select @temp = @temp  / 10
	end
	select @Oldh2g2ID = (10 * @OldEntryID) + (9 - @Oldh2g2ID % 10)

	-- then insert the newly accepted recommendation into the accepted recommendations table
	-- status 1 = 'Accepted'
	insert into AcceptedRecommendations (RecommendationID, EntryID, OriginalEntryID, AcceptorID, Comments, Status)
	values (@recommendationid, @NewEntryID, @OldEntryID, @acceptorid, @comments, 1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END
	
	-- update the original entry ID to show it has been recommended
	--update GuideEntries set Status = 4 where EntryID = @OldEntryID

	-- Give the acceptor edit permissions on the new article
	-- Make sure this is done after the h2g2ID ahs been calculated
	INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
		SELECT g.h2g2ID, ut.TeamID, 1, 1, 1, 1
			FROM GuideEntries g
				JOIN UserTeams ut ON ut.UserID = @acceptorid AND ut.SiteID = g.SiteID
			WHERE g.h2g2ID = @Checksum
--		SELECT @Checksum, TeamID, 1, 1, 1, 1 
--		FROM Users
--		WHERE UserId = @acceptorid 

	-- now add edit history info for both the old and new entries
	-- old entry
	insert into EditHistory (EntryID, UserID, DatePerformed, Action, Comment)
	values (@OldEntryID, @acceptorid, getdate(), 8, 'Scout recommendation accepted (copy made A' + CAST(@checksum As varchar) + ',DB' + CAST(@NewEntryID as varchar) + ')')
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	-- new entry
	insert into EditHistory (EntryID, UserID, DatePerformed, Action, Comment)
	values (@NewEntryID, @acceptorid, getdate(), 11, 'Copy of Scout recommended entry A' + CAST(@Oldh2g2ID As varchar) + ',DB' + CAST(@OldEntryID As varchar))
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	EXEC openemailaddresskey

	-- return a field to indicate success if we get here with no errors
	-- also return data required to send personalised email to scout
	select 'Success' = 1, dbo.udf_decryptemailaddress(U1.EncryptedEmail,U1.userid) as ScoutEmail, U1.Username as ScoutName, 
		dbo.udf_decryptemailaddress(U2.EncryptedEmail,U2.UserID) as AuthorEmail, U2.Username as AuthorName, G.h2g2ID, G.Subject, SR.DateRecommended
	from ScoutRecommendations SR
	inner join Users U1 on U1.UserID = SR.ScoutID
	inner join AcceptedRecommendations AR on AR.RecommendationID = SR.RecommendationID
	inner join GuideEntries G on G.EntryID = AR.EntryID
	inner join Users U2 on U2.UserID = @OldEditor
	where SR.RecommendationID = @recommendationid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION
end
else
begin
	-- if id provided doesn't exist then return failure
	select 'Success' = 0
end
return (0)
