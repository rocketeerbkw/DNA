/*
Purpose:
	Moves existing profanities into terms tables
	Creates id for each terms by inserting into termslookup table - this also converts to nvarchars
	Migrates the modclassid/profanity combinations with relevant action into new tables
	Checks that the correct amount moved and then commits transaction - otherwise returns error
*/

begin tran

declare @profcount int

select @profcount =  count(*) 
from
	profanities p
	inner join moderationclass mc on mc.modclassid = p.modclassid --added for data integrity - ensure that profanities only contains valid modclassid's

print 'Original profanity modclass combinations:' + cast(@profcount as varchar(10))

insert into TermsLookup
select distinct(profanity)
from 
	profanities
where 
	profanity not in
	( 
		select 
			term 
		from 
			TermsLookup
	)

declare @migratedcount int

insert into TermsByModClass
select 
	t.id as termid,
	p.modclassid as modclassid,
	case when p.refer = 1 then 1 else 2 end as actionid
from
	profanities p
	inner join termslookup t on t.term = p.profanity
	inner join moderationclass mc on mc.modclassid = p.modclassid --added for data integrity - ensure that profanities only contains valid modclassid's

set @migratedcount = @@rowcount

print 'Migrated term modclass combinations:' + cast(@migratedcount as varchar(10))

if @migratedcount <> @profcount
BEGIN
	
	RAISERROR ('Incorrect number of items migrated', 16, 1)
	rollback tran
END
ELSE
BEGIN
	commit tran
	
	--RAISERROR ('Correct number of items migrated', 16, 1)
	--rollback tran
END