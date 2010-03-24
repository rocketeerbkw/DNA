create procedure contentsignifincrementusersubscribe @userid int
as
begin
	--update any existing records
	update ContentSignifUser
	set Score = Score + csi.Value, 
		ScoreLastIncrement = GetDate()
	from ContentSignifUser as csu
	inner join ContentSignifIncrement csi on csu.Userid = @userid
		and csu.SiteID = csi.SiteID
		and ActionID = 10
		and ItemID = 1

	--insert any missing records
	insert into ContentSignifUser (UserID, Score, SiteID, ScoreLastIncrement, DateCreated)
	select @UserID, Value, SiteID, GetDate(), GetDate()
	from ContentSignifIncrement
	where	ActionID = 10 
		and ItemID = 1 
		and SiteID NOT IN( select SiteID from ContentSignifUser where UserID = @UserID)
		
	return 0;
end