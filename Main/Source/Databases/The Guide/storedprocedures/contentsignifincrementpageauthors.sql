create procedure contentsignifincrementpageauthors @entryid int, @siteid int, @increment int
as
begin
	--update any existing records
	update ContentSignifUser
	set Score = Score + @increment, 
		ScoreLastIncrement = GetDate()
	from ContentSignifUser as csu
	inner join Researchers r on r.UserID = csu.UserID
	Where r.EntryID = @entryid and csu.siteid = @siteid

	--insert any missing records
	insert into ContentSignifUser (UserID, Score, SiteID, ScoreLastIncrement, DateCreated)
	select r.UserID, @increment, @siteid, GetDate(), GetDate()
	FROM Researchers r
	WHERE r.EntryID = @entryid
		and NOT EXISTS ( select UserID from ContentSignifUser csu where csu.UserID = r.UserID and csu.siteid = @siteid)
		
	return 0;
end