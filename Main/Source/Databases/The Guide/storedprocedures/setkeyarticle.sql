CREATE PROCEDURE setkeyarticle	@articlename varchar(255),
									@h2g2id int,
									@siteid int,
									@allowothersites int,
									@dateactive datetime = NULL
As
declare @entryid int, @actualsiteid int
select @entryid = EntryID, @actualsiteid = SiteID
	FROM GuideEntries
	WHERE h2g2ID = @h2g2ID

if (@entryid IS NULL)
BEGIN
	SELECT 'Success' = 0, 'Error' = 'NOARTICLE'
END
ELSE
BEGIN
	IF ((@actualsiteid <> @siteid) AND (@allowothersites = 0))
	BEGIN
		SELECT 'Success' = 0, 'Error' = 'BADSITE'
	END
	ELSE
	BEGIN
		if (@dateactive IS NULL)
		BEGIN
			SET @dateactive = getdate()
		END

		INSERT INTO KeyArticles (EntryID, ArticleName, DateActive, SiteID)
		VALUES(@entryid, @articlename, @dateactive, @siteid)
		--UPDATE GuideEntries SET Status = 9 WHERE h2g2ID = @h2g2ID
		SELECT 'Success' = 1
	END
END