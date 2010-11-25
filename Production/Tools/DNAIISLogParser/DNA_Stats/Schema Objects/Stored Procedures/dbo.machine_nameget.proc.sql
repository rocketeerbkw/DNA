CREATE PROCEDURE [dbo].[machine_nameget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	machine_name
	where value=@value

	if @id is null
	BEGIN
		insert into machine_name
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


