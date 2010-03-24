CREATE PROCEDURE getmatchinguseraccounts @firstnames varchar(255), @lastname varchar(255), @email varchar(255)
AS
BEGIN
SELECT * FROM Users WHERE (FirstNames = @firstnames AND LastName = @lastname) OR (Email=@email)
END
