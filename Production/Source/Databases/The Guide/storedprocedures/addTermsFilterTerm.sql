Create Procedure addtermsfilterterm	@term nvarchar(50), @actionid int, @modclassid int, @historyid int
As

	declare @termId int
	
	--match existing term
	select 
		@termId = id
	from
		TermsLookup
	where
		term = @term
		
	if @termId is null
	BEGIN
		-- doesn't exist so create it..
		insert into TermsLookup
			(term)
		values
			(@term)
		
		select @termId = @@identity 
	END
	
	if @actionid = 0
	BEGIN
		delete from TermsByModClass
		where termId=@termId
			and modclassid = @modclassid
	END
	ELSE
	BEGIN
		--update the action in the table
		update TermsByModClass
		set 
			actionid = @actionid
		where
			termid = @termId
			and modclassid = @modclassid
			
		if @@rowcount = 0
		BEGIN-- no matches - so insert
			insert into TermsByModClass
				(termid, modclassid, actionid)
			values
				(@termid, @modclassid, @actionid)
		END
	END
	--insert into history
	insert into TermsByModClassHistory
			(termid, modclassid, actionid, updateid)
		values
			(@termId, @modclassid, @actionid, @historyid)
	
		
	
	