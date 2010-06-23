CREATE PROCEDURE generatesnesevents @topeventid INT
AS
BEGIN
	declare @siteid int
	select @siteid = siteid from sites where urlname = 'iplayertv'
	
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
	and EXISTS(select *
		from ThreadEntries TE 
        INNER JOIN Forums F on F.ForumID = TE.ForumID
        where TE.EntryID = EQ.ItemID2 AND f.siteid=@siteid)
END

RETURN 0;