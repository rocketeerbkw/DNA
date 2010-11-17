CREATE PROCEDURE [dbo].[http_methodget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	http_method
	where value=@value

	if @id is null
	BEGIN
		insert into http_method
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


