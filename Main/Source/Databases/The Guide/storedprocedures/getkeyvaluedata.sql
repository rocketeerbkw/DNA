CREATE PROCEDURE getkeyvaluedata @datakey uniqueidentifier
AS
DECLARE @DataValue Xml
SELECT @DataValue = DataValue FROM dbo.KeyValueData WHERE DataKey = @datakey
DELETE FROM dbo.KeyValueData WHERE DataKey = @datakey
SELECT 'DataValue' = @DataValue