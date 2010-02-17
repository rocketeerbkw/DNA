DECLARE @asciicode AS INT
SET @asciicode = 0

BEGIN TRANSACTION 

WHILE ( @asciicode < 256 )
BEGIN
	-- Remove control / non-printable characters
	IF ( @asciicode < 33 OR @asciicode = 127 OR @asciicode > 254 )
	BEGIN
		--If an occurence of an invalid character is found remove it.	
		IF EXISTS ( SELECT * FROM BannedEmails WHERE CHARINDEX(CHAR(@asciicode), Email) > 0 )
		BEGIN
			--Delete any duplicate BannedEmail.
			IF EXISTS ( SELECT B1.Email
							FROM BannedEmails B1
							INNER JOIN BannedEmails B2 ON B2.Email = REPLACE(B1.Email, CHAR(@asciicode),'')
							WHERE CHARINDEX(CHAR(@asciicode),B1.Email) > 0 )
			BEGIN
				SELECT 'Deleting duplicate banned emails',*, @asciicode 'Non-valid ascii'
				FROM BannedEmails B1
				INNER JOIN BannedEmails B2 ON B2.Email = REPLACE(B1.Email, CHAR(@asciicode),'')
				WHERE CHARINDEX(CHAR(@asciicode),B1.Email) > 0 
				
				--Delete banned email if a cleansed one already exists
				DELETE FROM BannedEmails
				WHERE Email IN (
				SELECT B1.Email
				FROM BannedEmails B1
				INNER JOIN BannedEmails B2 ON B2.Email = REPLACE(B1.Email, CHAR(@asciicode),'') 
				WHERE CHARINDEX(CHAR(@asciicode),B1.Email) > 0 )
			END
	
			--SELECT 'Correcting Banned Emails:', * FROM BannedEmails WHERE CHARINDEX(CHAR(@asciicode),Email) > 0
			UPDATE BannedEmails SET Email = REPLACE(Email, CHAR(@asciicode),'')
			WHERE CHARINDEX(CHAR(@asciicode),Email) > 0
			IF @@ERROR > 0 
			BEGIN
				ROLLBACK TRANSACTION 
				RETURN
			END
		END
	END 

	SET @asciicode = @asciicode + 1
END

COMMIT TRANSACTION