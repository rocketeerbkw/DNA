select so.SiteID
  into #SitesThatDontUseMastheads
  from SiteOptions so
 where so.Name = 'IsMessageboard'
   and so.Value = 1

-- closed sites do not use mastheads.
insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'cbbc'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = '360'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'place-london'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'place-nireland'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'place-devon'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'ptop'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'onthefuture'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'ww2'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'getwriting'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'onionstreet'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'place-lancashire'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'cult'

insert into #SitesThatDontUseMastheads
select SiteID
  from Sites
 where URLName = 'dannywallace'


create table #MultiSiteUsers (UserID int, SiteID int)

-- get all users that have contributed to DNA sites. 
insert into #MultiSiteUsers (UserID, SiteID)
select Editor, SiteID
  from dbo.GuideEntries 
union
select te.UserID, f.SiteID
  from dbo.ThreadEntries te
		inner join dbo.Forums f on f.ForumID = te.ForumID
union
select vm.UserID, c.SiteID
  from Votes v
		inner join VoteMembers vm on vm.VoteID = v.VoteID
		inner join ClubVotes cv on cv.VoteID = v.VoteID
		inner join Clubs c on c.ClubID = cv.ClubID
union 
select vm.UserID, f.SiteID
  from Votes v
		inner join VoteMembers vm on vm.VoteID = v.VoteID
		inner join ThreadVotes tv on tv.VoteID = v.VoteID
		inner join Threads t on t.ThreadID = tv.ThreadID
		inner join Forums f on f.ForumID = t.ForumID
union
select vm.UserID, ge.SiteID
  from Votes v
		inner join VoteMembers vm on vm.VoteID = v.VoteID
		inner join PageVotes pv on pv.VoteID = v.VoteID
		inner join GuideEntries ge on ge.h2g2ID = pv.ItemID and pv.ItemType = 1
union 
select vm.UserID, c.SiteID
  from Votes v
		inner join VoteMembers vm on vm.VoteID = v.VoteID
		inner join PageVotes pv on pv.VoteID = v.VoteID
		inner join Clubs c on c.h2g2ID = pv.ItemID and pv.ItemType = 2
union 
select vm.UserID, f.SiteID
  from Votes v
		inner join VoteMembers vm on vm.VoteID = v.VoteID
		inner join PageVotes pv on pv.VoteID = v.VoteID
		inner join Threads t on t.ThreadID = pv.ItemID and pv.ItemType = 2
		inner join Forums f on f.ForumID = t.ForumID
union
select UserID, SiteID
  from AlertGroups
union
select UserID, c.SiteID
  from Clubs c
		inner join TeamMembers tm on c.OwnerTeam = tm.TeamID
union 
select ComplainantID, SiteID
  from ThreadMod
 where ComplainantID IS NOT NULL 
union 
select ComplainantID, SiteID
  from ArticleMod
 where ComplainantID IS NOT NULL 
union 
select r.UserID, ge.SiteID
  from dbo.Researchers r
		inner join GuideEntries ge on r.EntryID = ge.EntryID

-- Cursor round users that have contributed to more than 1 site. 
DECLARE MultiSiteUsers_Cursor CURSOR FAST_FORWARD FOR
SELECT msu.UserID, msu.SiteID
  FROM #MultiSiteUsers msu
 WHERE msu.UserID in (SELECT msu2.UserID
						FROM #MultiSiteUsers msu2
					   GROUP BY msu2.UserID
					  HAVING COUNT(*) > 1)
   AND msu.UserID != 0 
   AND msu.SiteID != 0
 ORDER BY msu.UserID, msu.SiteID

OPEN MultiSiteUsers_Cursor 

DECLARE @CurUserID INT 
DECLARE @SiteID INT 
DECLARE @CurError INT
DECLARE @FirstGEh2g2ID INT
DECLARE @FirstGEHidden INT
DECLARE @FirstGEStatus INT
DECLARE @NewMastheadh2g2ID INT
DECLARE @PreMod INT
DECLARE @Unmoderated INT
DECLARE @modid INT
DECLARE @ModStatus INT

FETCH NEXT FROM MultiSiteUsers_Cursor 
INTO @CurUserID, @SiteID

WHILE @@FETCH_STATUS = 0
BEGIN
	-- create masthead, journal and message centres. 
	EXEC @CurError = populateuseraccount @userid = @CurUserID, 
										 @siteid = @SiteID

	IF @Curerror <> 0
	BEGIN
		PRINT 'Error in populateuseraccount! UserID = ' + CAST(@CurUserID as varchar(8))+ ', SiteID = ' + CAST(@SiteID as varchar(8))
		CONTINUE
	END

	-- get hidden and status flags of the orignial mashhead, i.e. the masthead associated with the site on which the user first signed-up. 
	SELECT @FirstGEh2g2ID = ge.h2g2ID, 
		   @FirstGEHidden = ge.Hidden, 
		   @FirstGEStatus = ge.Status
	  FROM dbo.Users u
			INNER JOIN dbo.GuideEntries ge on u.Masthead = ge.h2g2ID
	 WHERE u.UserID = @CurUserID

	-- get new Masthead for site
	SELECT @NewMastheadh2g2ID = dbo.udf_generateh2g2id(m.EntryID)
	  FROM dbo.Mastheads m
	 WHERE m.UserID = @CurUserID
	   AND m.SiteID = @SiteID

	-- get moderation status the site being migrated to. 
	SELECT @PreMod		= PreModeration, 
		   @Unmoderated = Unmoderated
	  FROM dbo.Sites
	 WHERE SiteID = @SiteID

	IF (@FirstGEh2g2ID != @NewMastheadh2g2ID)
	BEGIN
		-- I.e. this is not the original masthead

		IF EXISTS (SELECT *
				     FROM GuideEntries
				    WHERE h2g2ID = @FirstGEh2g2ID
				      AND (Subject = '' OR Subject IS NULL)
				      AND (CAST(text as varchar(8000)) = '' OR text IS NULL)
				   )
		BEGIN
			update GuideEntries
			   set Hidden = null
			 where h2g2ID = @NewMastheadh2g2ID
		END
		ELSE
		BEGIN
			-- update user's masthead with subject, text, extrainfo and status flags. 
			update dbo.GuideEntries
			   set Subject = fstge.Subject, 
				   text = fstge.text, 
				   ExtraInfo = fstge.ExtraInfo, 
				   Style = fstge.Style, 
				   Status = fstge.Status, 
				   Hidden = fstge.Hidden
			  from dbo.GuideEntries 
					inner join Mastheads m on GuideEntries.EntryID = m.EntryID
					inner join Users u on m.UserID = u.UserID
					inner join GuideEntries fstge on u.Masthead = fstge.h2g2ID
			 where m.SiteID = @SiteID 
			   and m.UserID = @CurUserID

			IF (@@ERROR <> 0)
			BEGIN
				PRINT 'Error in updating new masthead! UserID = ' + CAST(@CurUserID as varchar(8))+ ', SiteID = ' + CAST(@SiteID as varchar(8))
				CONTINUE
			END

			IF (((@FirstGEHidden IS NOT NULL) OR (@PreMod = 1 OR (@PreMod = 0 and @Unmoderated = 0))) AND (@FirstGEStatus != 7))
			BEGIN
				-- original masthead is hidden OR destinatation site is moderated AND original masthead not cancelled. 
				IF EXISTS(SELECT *
							FROM #SitesThatDontUseMastheads
						   WHERE SiteID = @SiteID)
				BEGIN
					-- No need to copy original mast head subject/text. No need to put it in moderation.
					UPDATE GuideEntries
					   SET Hidden = NULL, 
						   Subject = '', 
						   Text = ''
					 WHERE h2g2ID = @NewMastheadh2g2ID

					IF (@CurError <> 0)
					BEGIN
						PRINT 'Error in unhiding new masthead on site that does not use mastheads! UserID = ' + CAST(@CurUserID as varchar(8))+ ', SiteID = ' + CAST(@SiteID as varchar(8))
						CONTINUE
					END
				END
				ELSE
				BEGIN
					SELECT @ModStatus = NULL

					SELECT @ModStatus = Status
					  FROM ArticleMod
					 WHERE h2g2ID = @FirstGEh2g2ID
					   AND ModID = (SELECT MAX(ModID)
									  FROM ArticleMod
									 WHERE h2g2ID = @FirstGEh2g2ID)

					IF (((@ModStatus != 3) AND (@ModStatus != 4) AND (@ModStatus != 6)) OR (@ModStatus IS NULL))
					BEGIN
						-- Moderation decision still outstanding (i.e. has not been passed, failed or failed and edited)
						-- or there is no Moderation record for the original masthead (so we put it in the moderation system for safety). 
						SELECT @modid = NULL 

						-- If Mod status of original masthead is not 3, 4 or 6 (i.e. passed, failed or failed and edited) or there is no row in ArticleMod table for the original masthead.
						EXEC @CurError = queuearticleformoderation @h2g2id		= @NewMastheadh2g2ID, 
																   @triggerid	= 3, -- Auto
																   @triggeredby = NULL, 
																   @notes		= 'Personal space migration', 
																   @modid		= @modid output

						IF (@CurError <> 0)
						BEGIN
							PRINT 'Error in updating new masthead! UserID = ' + CAST(@CurUserID as varchar(8))+ ', SiteID = ' + CAST(@SiteID as varchar(8))
							CONTINUE
						END
					END
				END
			END
		END
	END

	FETCH NEXT FROM MultiSiteUsers_Cursor 
	 INTO @CurUserID, @SiteID
END

CLOSE MultiSiteUsers_Cursor 
DEALLOCATE MultiSiteUsers_Cursor 

drop table #MultiSiteUsers
drop table #SitesThatDontUseMastheads
