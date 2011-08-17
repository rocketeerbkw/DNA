Create Procedure updateuser	@userid int,
								@email varchar(255) = NULL, 
								@username varchar(255) = NULL,
								@password varchar(255) = NULL,
								@firstnames varchar(255) = NULL,
								@lastname varchar(255) = NULL,
								@masthead int = NULL,
								@active int = NULL,
								@status int = NULL,
								@anonymous int = NULL
As

EXEC openemailaddresskey

declare @set varchar(4000)
declare @comma varchar(5)
IF @username IS NOT NULL
BEGIN
	SELECT @username = REPLACE(@username, '<', '&lt;')
	SELECT @username = REPLACE(@username, '>', '&gt;')
END
SELECT @comma = ''
SELECT @set = ''
IF NOT (@masthead IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Masthead = ' + CAST(@masthead AS varchar(50))
SELECT @comma = ' , '
END
IF NOT (@active IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Active = ' + CAST(@active AS varchar(50))
SELECT @comma = ' , '
END
IF NOT (@status IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Status = ' + CAST(@status AS varchar(50))
SELECT @comma = ' , '
END
IF NOT (@anonymous IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Anonymous = ' + CAST(@anonymous AS varchar(50))
SELECT @comma = ' , '
END
IF NOT (@email IS NULL)
BEGIN
SELECT @set = @set + @comma + 'EncryptedEmail = dbo.udf_encryptemailaddress(' + QUOTENAME(@email,'''') + ',UserId)'
SELECT @comma = ' , '
END
IF NOT (@username IS NULL)
BEGIN
SELECT @set = @set + @comma + 'UserName = ' + QUOTENAME(@username,'''')
SELECT @comma = ' , '
END
IF NOT (@password IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Password = ' + QUOTENAME(@password,'''')
SELECT @comma = ' , '
END
IF NOT (@firstnames IS NULL)
BEGIN
SELECT @set = @set + @comma + 'FirstNames = ' + QUOTENAME(@firstnames,'''')
SELECT @comma = ' , '
END
IF NOT (@lastname IS NULL)
BEGIN
SELECT @set = @set + @comma + 'LastName = ' + QUOTENAME(@lastname,'''')
SELECT @comma = ' , '
END
IF (@set <> '')
BEGIN
declare @query varchar(4096)
SELECT @query = 'UPDATE Users SET ' + @set + ' WHERE UserID = ' + CAST(@userid AS varchar(40))
EXEC (@query)
END
	return (0)