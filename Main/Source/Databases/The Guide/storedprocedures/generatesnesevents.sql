CREATE PROCEDURE generatesnesevents @topeventid INT
AS
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
RETURN 0;