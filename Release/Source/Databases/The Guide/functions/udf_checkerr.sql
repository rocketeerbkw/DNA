-- udf_checkerr() makes it easier to cope with two error codes, in the situation when you call
-- an SP from within another SP.
-- e.g.
--       EXEC @err = mysp
--
-- In this situation you need to check @err for an error code returned by the SP.
-- You ALSO need to test @@ERROR in case the actual EXEC call failed.  
-- This func allows you to do something like :
-- 
--       EXEC @err = mysp
--       SET @err = dbo.udf_checkerr(@@ERROR,@err); IF @err <> 0 GOTO HandleError

CREATE FUNCTION udf_checkerr(@e1 int,@e2 int)
RETURNS INT
AS
BEGIN
	IF @e1 <> 0 
		RETURN @e1
		
	RETURN @e2
END