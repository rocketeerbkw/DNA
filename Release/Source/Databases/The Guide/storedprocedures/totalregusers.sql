CREATE Procedure totalregusers
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 'cnt' = COUNT(*) FROM Users WHERE Active = 1
