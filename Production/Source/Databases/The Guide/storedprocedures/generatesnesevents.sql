CREATE PROCEDURE generatesnesevents @topeventid INT
AS
INSERT INTO SNeSActivityQueue
	SELECT	EQ.EventType,
			EQ.ItemID,
			EQ.ItemType,
			EQ.ItemID2,
			EQ.ItemType2,
			EQ.EventDate,
			EQ.EventUserID
	FROM EventQueue EQ
		INNER JOIN SignInUserIDMapping S ON S.DNAUserID = EQ.EventUserID
		INNER JOIN ThreadEntries TE ON TE.EntryID = EQ.ItemID2
		INNER JOIN Forums F ON F.ForumID = TE.ForumID
	WHERE EQ.EventType IN (19,20) 
		AND	S.IdentityUserID IS NOT NULL
		AND dbo.udf_GetSiteOptionSetting(f.siteid, 'SNeS Integration', 'Enabled') ='1'
		AND dbo.udf_GetSiteOptionSetting(f.siteid, 'General', 'SiteIsPrivate') ='0'
		AND EQ.EventID <= @TopEventID

/*	
BEGIN
	INSERT INTO SNeSActivityQueue
		select EQ.EventType,
			EQ.ItemID,
			EQ.ItemType,
			EQ.ItemID2,
			EQ.ItemType2,
			EQ.EventDate,
			EQ.EventUserID
	from EventQueue EQ
	inner join SignInUserIDMapping S on S.DNAUserID = EQ.EventUserID
	where EQ.EventType in (19,20) 
	and	S.IdentityUserID is not null
	and EQ.EventID <= @TopEventID
	and EXISTS(
	
		select *
		from ThreadEntries TE 
		INNER JOIN Forums F on F.ForumID = TE.ForumID
		where TE.EntryID = EQ.ItemID2 
			AND dbo.udf_GetSiteOptionSetting(f.siteid, 'SNeS Integration', 'Enabled') ='1'
			AND dbo.udf_GetSiteOptionSetting(f.siteid, 'General', 'SiteIsPrivate') ='0'
		)
END
*/
RETURN 0;