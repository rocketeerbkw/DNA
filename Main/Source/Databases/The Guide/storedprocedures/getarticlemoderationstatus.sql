Create Procedure getarticlemoderationstatus @h2g2id int
As

declare @moderationstatus int

BEGIN
	select @moderationstatus=ModerationStatus from GuideEntries g where g.h2g2ID = @h2g2id
END

if not(@moderationstatus IS NULL)
BEGIN
	select 'ModerationStatus' = @moderationstatus
END
