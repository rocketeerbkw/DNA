CREATE PROCEDURE [dbo].[http_statusget] @value varchar(50), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	http_status
	where value=@value

	if @id is null
	BEGIN
		insert into http_status
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


