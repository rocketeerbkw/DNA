CREATE PROCEDURE [dbo].[perf_instanceget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	perf_instance
	where value=@value

	if @id is null
	BEGIN
		insert into perf_instance
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


