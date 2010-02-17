DECLARE @myid uniqueidentifier
declare @counter int;
declare @userid int;

set @counter = 24
select @userid=userid from users where username='jamestest1'

WHILE (@counter != 0) begin

	SET @myid = NEWID()
	PRINT 'Value of @myid is: '+ CONVERT(varchar(255), @myid)
	exec dbo.posttoforum @userid, 19585, NULL, NULL, 'test posting james', 'yadayada<smiley><biggrin><cool><wah><choc>', 2, @myid, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '', 1

	WAITFOR DELAY '000:01:00'

	set @counter = @counter -1;

end --while

set @counter = 49
select @userid=userid from users where username='2jamestest'

WHILE (@counter != 0) begin

	SET @myid = NEWID()
	PRINT 'Value of @myid is: '+ CONVERT(varchar(255), @myid)
	exec dbo.posttoforum @userid, 19585, NULL, NULL, 'test posting james', 'yadayada<smiley><biggrin><cool><wah><choc>', 2, @myid, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '', 1

	WAITFOR DELAY '000:01:00'

	set @counter = @counter -1;

end --while

set @counter = 399
select @userid=userid from users where username='3jamestest'

WHILE (@counter != 0) begin

	SET @myid = NEWID()
	PRINT 'Value of @myid is: '+ CONVERT(varchar(255), @myid)
	exec dbo.posttoforum @userid, 19585, NULL, NULL, 'test posting james', 'yadayada<smiley><biggrin><cool><wah><choc>', 2, @myid, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '', 1

	WAITFOR DELAY '000:01:00'

	set @counter = @counter -1;

end --while

set @counter = 401
select @userid=userid from users where username='4jamestest'

WHILE (@counter != 0) begin

	SET @myid = NEWID()
	PRINT 'Value of @myid is: '+ CONVERT(varchar(255), @myid)
	exec dbo.posttoforum @userid, 19585, NULL, NULL, 'test posting james', 'yadayada<smiley><biggrin><cool><wah><choc>', 2, @myid, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '', 1

	WAITFOR DELAY '000:01:00'

	set @counter = @counter -1;

end --while




