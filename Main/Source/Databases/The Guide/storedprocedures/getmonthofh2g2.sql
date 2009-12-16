Create Procedure getmonthofh2g2	@h2g2id int
As
	declare @articledate datetime, @mostrecent datetime

	SELECT @articledate = DateCreated FROM GuideEntries WHERE h2g2ID = @h2g2id
	SELECT @mostrecent = MAX(DateCreated) FROM GuideEntries WHERE DateCreated < getdate() AND status = 1
	if @articledate <= @mostrecent
	BEGIN
		SELECT DateCreated, Subject, h2g2ID FROM GuideEntries WHERE DateCreated>= DATEADD(month,-1,getdate()) AND status = 1 AND DateCreated < getdate() ORDER BY DateCreated DESC
	END
	return (0)