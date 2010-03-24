create procedure copylinkstoclub @userid int, @clubid int, @linkgroup varchar(50)
as
BEGIN TRANSACTION

DECLARE @clubownerteam int
SELECT @clubownerteam=ownerteam FROM clubs WHERE clubid=@clubid

IF @clubownerteam IS NOT NULL
BEGIN
	declare @totallinks int
	INSERT INTO Links (SourceType, SourceID, DestinationType, DestinationID, LinkDescription, DateLinked, Explicit, Type, Hidden, Private, TeamID, Relationship, DestinationSiteId)
	SELECT 'club', @clubid, DestinationType, DestinationID, LinkDescription, getdate(), 0, Type, Hidden, Private, @clubownerteam, Relationship, DestinationSiteId
		FROM Links WHERE SourceType = 'userpage' AND SourceID = @userid AND Type = @linkgroup
	SELECT @totallinks = @@ROWCOUNT
	SELECT 'result' = 'success', 'totalcopied' = @totallinks
END
ELSE
BEGIN
	SELECT 'result' = 'nosuchclub'
END

COMMIT TRANSACTION