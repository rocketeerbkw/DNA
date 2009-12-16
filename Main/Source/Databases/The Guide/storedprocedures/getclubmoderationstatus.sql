Create Procedure getclubmoderationstatus @clubid int
As

declare @moderationstatus int

BEGIN
	-- The club's moderation status is defined by it's associated article's moderation status
	SELECT @moderationstatus=ModerationStatus FROM GuideEntries g, Clubs c 
			WHERE g.h2g2ID = c.h2g2id and c.clubid = @clubid
END

if not(@moderationstatus IS NULL)
BEGIN
	select 'ModerationStatus' = @moderationstatus
END
