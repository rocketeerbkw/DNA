CREATE PROCEDURE moderateimage @imageid int, 
	@modid int, @status int, @notes varchar(2000), @referto int, @referredby int
As
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

IF @status = 5 --unrefer
BEGIN
	UPDATE ImageMod 
	SET Status = 1, 
		Notes = @Notes,
		DateLocked = GETDATE(),
		DateReferred = NULL,  
		LockedBy = ReferredBy, 
		ReferredBy = NULL
	WHERE ModID = @ModID
END
ELSE
BEGIN
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

	DECLARE @ErrorCode INT

	-- Update the ThreadMod line for this moderation
	-- make sure we don't overwrite any existing dates however
	UPDATE ImageMod
		SET	Status = @realStatus,
			Notes = @notes,
			DateLocked = isnull(@DateLocked, DateLocked),
			DateReferred = isnull(@datereferred, DateReferred),
			DateCompleted = isnull(@datecompleted, DateCompleted),
			LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE LockedBy END,
			ReferredBy = CASE WHEN @realStatus = 2 THEN @referredby ELSE ReferredBy END
		WHERE ModID = @modid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- finally return the authors and complainants email addresses
	SELECT	'AuthorsEmail' = u.Email,
			'AuthorID' = u.UserID, 
			'ComplainantsEmail' = im.CorrespondenceEmail,
			'ComplainantID' = im.ComplainantID
		FROM ImageMod im INNER JOIN ImageLibrary il ON il.ImageID = im.ImageID
			INNER JOIN Users u ON u.UserID = il.UserID
		WHERE im.ModID = @ModID
END