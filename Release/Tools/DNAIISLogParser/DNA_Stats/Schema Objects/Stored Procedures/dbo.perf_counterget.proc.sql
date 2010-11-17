CREATE PROCEDURE [dbo].[perf_counterget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_counter
	where value=@value

	if @id is null
	BEGIN
		insert into perf_counter
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


