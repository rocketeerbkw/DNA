CREATE PROCEDURE [dbo].[siteget] @value varchar(50)='', @id int output
AS
BEGIN
	SET NOCOUNT ON;
	
	select @id = id
	from	site
	where value=@value

	if @id is null
	BEGIN
		insert into site
		(value)
		values
		(@value)

		set @id = @@identity
    END
END


