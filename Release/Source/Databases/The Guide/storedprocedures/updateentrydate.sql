Create Procedure updateentrydate @entryid int
As
UPDATE GuideEntries SET DateCreated = getdate() WHERE EntryID = @entryid
	return (0)