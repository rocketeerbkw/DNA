CREATE PROCEDURE savekeyvaluedata @datavalue varchar(MAX)
AS
DECLARE @DataKey UniqueIdentifier
SET @DataKey = NewID()
INSERT INTO dbo.KeyValueData (DataKey,DataValue) SELECT @DataKey, @datavalue
SELECT 'DataKey' = @DataKey