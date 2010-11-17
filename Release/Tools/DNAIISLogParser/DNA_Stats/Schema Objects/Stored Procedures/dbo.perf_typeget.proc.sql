CREATE PROCEDURE [dbo].[perf_typeget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_type
	where value=@value

	if @id is null
	BEGIN
		insert into perf_type
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


