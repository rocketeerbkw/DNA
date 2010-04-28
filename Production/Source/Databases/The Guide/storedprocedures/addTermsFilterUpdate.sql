Create Procedure addtermsfilterupdate		@userid int, @notes ntext
As

	insert into TermsUpdateHistory
	(userid, notes)
	values
	(@userid,@notes)
	
	select cast(@@identity as int) as historyId