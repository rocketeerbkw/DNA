CREATE PROCEDURE isuseramemberofthisteam @teamid INT, @userid INT
AS
BEGIN
		DECLARE @Count INT
		SELECT TOP 1 @Count = userid
		FROM dbo.teammembers	
		WHERE teamid = @teamid AND userid = @userid 
		
		IF @Count > 0
			SELECT 'IsAMember' = 1
		ELSE
			SELECT 'IsAMember' = 0
END