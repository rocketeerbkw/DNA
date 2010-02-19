
DECLARE @asciicode AS INT
SET @asciicode = 0

BEGIN TRANSACTION 

WHILE ( @asciicode < 256 )
BEGIN
	-- Remove control / non-printable characters
	IF ( @asciicode < 32 OR @asciicode = 127 OR @asciicode > 253 )
	BEGIN
		--If an occurence of an invalid character is found remove it.	
		IF EXISTS ( SELECT * FROM Profanities WHERE CHARINDEX(CHAR(@asciicode),Profanity) > 0 )
		BEGIN
			--Delete any duplicate profanity.
			IF EXISTS ( SELECT P1.ProfanityId 
							FROM Profanities P1
							INNER JOIN Profanities P2 ON P2.Profanity = REPLACE(P1.Profanity, CHAR(@asciicode),'') AND P2.ModClassId = P1.ModClassID
							WHERE CHARINDEX(CHAR(@asciicode),P1.Profanity) > 0 )
			BEGIN
				SELECT 'Deleting duplicate profanities',*
				FROM Profanities P1
				INNER JOIN Profanities P2 ON P2.Profanity = REPLACE(P1.Profanity, CHAR(@asciicode),'') AND P2.ModClassId = P1.ModClassID
				WHERE CHARINDEX(CHAR(@asciicode),P1.Profanity) > 0 
				
				--Delete profanity if a cleansed one already exists
				DELETE FROM Profanities
				WHERE ProfanityID IN (
				SELECT P1.ProfanityId 
				FROM Profanities P1
				INNER JOIN Profanities P2 ON P2.Profanity = REPLACE(P1.Profanity, CHAR(@asciicode),'') AND P2.ModClassId = P1.ModClassID
				WHERE CHARINDEX(CHAR(@asciicode),P1.Profanity) > 0 )
			END

			SELECT 'Correcting Profanities:', * FROM Profanities WHERE CHARINDEX(CHAR(@asciicode),Profanity) > 0
			UPDATE Profanities SET Profanity = REPLACE(Profanity, CHAR(@asciicode),'')
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