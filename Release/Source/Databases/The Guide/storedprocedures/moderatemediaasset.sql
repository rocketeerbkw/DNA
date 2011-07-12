CREATE PROCEDURE moderatemediaasset @modid int, @status int, @notes varchar(2000), @referto int, @userid int
As
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

declare @realStatus int
declare @datereferred datetime
declare @datecompleted datetime
declare @DateLocked datetime

select @realStatus = CASE @status WHEN 6 THEN 4 ELSE @status END

IF @realStatus = 2
BEGIN
	SELECT @datereferred = getdate()
	SELECT @datecompleted = NULL
	SELECT @DateLocked = getdate()
END
ELSE
BEGIN
	SELECT @DateLocked = NULL
	SELECT @datereferred = NULL
	SELECT @datecompleted = getdate()
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

declare @authorsemail varchar(255), @complainantsemail varchar(255), @assetid int
declare @authorid int, @complainantid int

EXEC openemailaddresskey

select	@authorsemail = dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId), 
		@authorid = U.UserID, 
		@complainantsemail = mod.Email, 
		@complainantid = mod.complainantid,
		@assetid = ma.ID
	from MediaAssetMod mod WITH(UPDLOCK)
	inner join mediaasset ma ON ma.[ID] = mod.mediaassetid
	inner join Users U WITH(NOLOCK) on U.UserID = ma.OwnerID
	where mod.ModID = @ModID
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END



-- Update the MediaAssetMod line for this moderation
-- make sure we don't overwrite any existing dates however
UPDATE MediaAssetMod
	SET	Status = @realStatus,
		Notes = @notes,
		DateLocked = isnull(@DateLocked, DateLocked),
		DateReferred = isnull(@datereferred, DateReferred),
		DateCompleted = isnull(@datecompleted, DateCompleted),
		LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE LockedBy END,
		ReferredBy = CASE WHEN @realStatus = 2 THEN @userid ELSE ReferredBy END
	WHERE ModID = @modid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- If it's failed moderation or been referred
IF (@realStatus = 4 and @status <> 6) or @realStatus = 2
BEGIN
	UPDATE MediaAsset SET LastUpdated = getdate() WHERE ID = @assetid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

-- If it's failed or passed moderation or been referred, update the Hidden Flag
IF (@realStatus = 3)
BEGIN
	UPDATE MediaAsset SET Hidden = NULL WHERE ID = @assetid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE IF (@realStatus = 4)
BEGIN
	UPDATE MediaAsset SET Hidden = 1 WHERE ID = @assetid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE IF (@realStatus = 2)
BEGIN
	UPDATE MediaAsset SET Hidden = 2 WHERE ID = @assetid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END


COMMIT TRANSACTION

-- finally return the authors and complainants email addresses
-- also return if this was a legacy moderation or not
select	'AuthorsEmail' = @authorsemail,
		'AuthorID' = @authorid,
		'ComplainantsEmail' = @complainantsemail,
		'ComplainantID' = @complainantid
