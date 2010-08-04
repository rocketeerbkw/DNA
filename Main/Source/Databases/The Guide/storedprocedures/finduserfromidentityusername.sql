CREATE PROCEDURE finduserfromidentityusername @identityusername varchar(255) = NULL, @siteid int = 1
AS

DECLARE @dnauserid INT
SET @dnauserid = dbo.udf_getdnauseridfromloginname(@identityusername)

EXEC finduserfromid @dnauserid, NULL, @siteid