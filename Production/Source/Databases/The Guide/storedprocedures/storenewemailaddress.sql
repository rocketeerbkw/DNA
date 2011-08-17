Create Procedure storenewemailaddress @userid int, @oldemail varchar(255), @newemail varchar(255)
As
RAISERROR('storenewemailaddress DEPRECATED',16,1)

/*
	Deprecated - never called
	
	declare @message varchar(255)
	IF NOT EXISTS (SELECT * FROM Users WHERE UserID = @userid AND email = @oldemail)
	BEGIN
		SELECT 'Success' = 0, 'SecretKey' = NULL, 'Message' = 'the old email address does not match the user''s existing email address'
	END
	ELSE IF EXISTS (SELECT * FROM Users WHERE email = @newemail)
	BEGIN
		SELECT 'Success' = 0, 'SecretKey' = NULL, 'Message' = 'the new email address is already used by another researcher'
	END
	ELSE
	BEGIN
	declare @rnd int
	SELECT @rnd = RAND( (DATEPART(mm, GETDATE()) * 100000 )
		       + (DATEPART(ss, GETDATE()) * 1000 )
			   + DATEPART(ms, GETDATE()) )
		INSERT INTO EmailChange (UserID, oldemail, newemail) VALUES (@userid, @oldemail, @newemail)
		declare @rownum int
		SELECT @rownum = @@IDENTITY

		SELECT 'Success' = 1, SecretKey, 'Message' = 'Success' FROM EmailChange WHERE rownum = @rownum
	END
	return (0)
*/