CREATE FUNCTION udf_generateh2g2id (@entryid int)
returns int
as
BEGIN
	declare @temp int, @Checksum int
	set @temp = @entryid
	set @Checksum = 0
	while @temp > 0
	begin
		set @Checksum = @Checksum + (@temp % 10)
		set @temp = @temp  / 10
	end
	return (10 * @entryid) + (9 - @Checksum % 10)
END
