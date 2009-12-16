create procedure copysinglelinktoclub @linkid int, @clubid int, @newlinkgroup varchar(50)
as
BEGIN TRANSACTION

	DECLARE @clubownerteam int
	SELECT @clubownerteam=ownerteam FROM clubs WHERE clubid=@clubid

	INSERT INTO Links (SourceType, SourceID, DestinationType, DestinationID, LinkDescription, DateLinked, Explicit, Type, Hidden, Private, TeamID, Relationship, DestinationSiteId )
	SELECT 'club', @clubid, DestinationType, DestinationID, LinkDescription, getdate(), 0, @newlinkgroup, Hidden, Private, @clubownerteam, Relationship, DestinationSiteId
		FROM Links WHERE LinkID = @linkid
	IF @@ROWCOUNT = 0
	BEGIN
		-- Find out which folder (if at all) it already exists in
		declare @existingtype varchar(50)
		declare @dtype varchar(50), @did int
		select @dtype = DestinationType, @did = DestinationID FROM Links WHERE LinkID = @linkid
		select @existingtype = Type from Links 
			WHERE SourceType = 'club' AND SourceID = @clubid AND DestinationType = @dtype AND DestinationID = @did
		IF (@existingtype IS NOT NULL)
		BEGIN
			select 'result' = 1, 'reason' = 'duplicate', 'type' = @existingtype
		END
		ELSE
		BEGIN
			select 'result' = 2, 'reason' = 'unknown'
		END
	END
	ELSE
	BEGIN
		select 'result' = 0 -- success
	END

COMMIT TRANSACTION