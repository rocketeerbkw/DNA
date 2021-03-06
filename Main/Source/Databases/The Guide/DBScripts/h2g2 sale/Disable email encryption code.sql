ALTER FUNCTION [dbo].[udf_decryptemailaddress]
(
	@encemailaddress varbinary(300),
	@userid int
)
RETURNS varchar(255)
AS
BEGIN
	-- See comments in SP openemailaddresskey for details
	RETURN NULL
END
GO
ALTER FUNCTION [dbo].[udf_encryptemailaddress]
(
	@emailaddress varchar(255),
	@userid int
)
RETURNS varbinary(8000)
AS
BEGIN
	-- See comments in SP openemailaddresskey for details
	RETURN NULL
END
GO
ALTER PROCEDURE [dbo].[openemailaddresskey]
AS
/*
	This would normally open a key that is subsequently used by the functions udf_encryptemailaddress and udf_decryptemailaddress.
	As there is no encrypted emails in the h2g2 database, no key has been defined, so this SP does nothing
*/
GO