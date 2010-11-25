CREATE PROCEDURE [dbo].[urlget] @value varchar(1000), @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	url
	where value=@value

	if @id is null
	BEGIN
		insert into url
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


