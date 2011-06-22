CREATE TRIGGER trg_ThreadEntriesIPAddress_iu ON ThreadEntriesIPAddress
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc
	
	-- If an IP address in the BBC range is being stored, change it to 
	-- an invalid IP to prevent hosts from trying to look the IP address up
	-- THIS IS A TEMPORARY FIX until the comments module is able to pass
	-- in the correct client IP address to the API calls
	--
	-- A BBC IP address is defined as being between 212.58.224 and 212.58.255 inclusive
	IF UPDATE(IPAddress)
	BEGIN
		DECLARE @ipaddress varchar(25), @EntryID int, @node int
		SELECT @ipaddress=IPAddress, @EntryID=EntryID FROM inserted
		IF LEFT(@ipaddress,8) = '212.58.2'
		BEGIN
			DECLARE @nodetext varchar(25)
			SET @nodetext=SUBSTRING(@ipaddress,8,3)
			IF CHARINDEX('.', @nodetext)=0
			BEGIN
				SET @node = CAST(@nodetext as int)
				IF @node >=224 AND @node <=255
				BEGIN
					UPDATE ThreadEntriesIPAddress SET IPAddress='0.0.0.0' WHERE EntryId=@EntryID
				END
			END
		END
	END