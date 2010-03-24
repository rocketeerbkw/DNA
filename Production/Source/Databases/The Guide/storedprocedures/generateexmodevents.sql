CREATE PROCEDURE generateexmodevents @topeventid INT
AS
	-- Get ExModerationLink Events. Don't want duplicates ( eg double clicks )
	DECLARE @type INT
	EXEC seteventtypevalinternal 'ET_EXMODERATIONDECISION', @type OUTPUT
	INSERT INTO ExModEventQueue ( modid) 
	SELECT DISTINCT eq.itemid as modid
	FROM eventqueue eq 
	WHERE eq.eventtype = @type and eq.eventid <= @topeventid
	