CREATE PROCEDURE testproc @param1 int = 123, @param2 int = 456, @param3 int  = 789
AS
SELECT 'Param1' = @param1, 'Param2' = @param2, 'Param3' = @param3