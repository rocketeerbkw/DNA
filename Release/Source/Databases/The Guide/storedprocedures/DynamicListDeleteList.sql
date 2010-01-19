Create Procedure dynamiclistdeletelist @id INT
AS

DELETE FROM DynamicListDefinitions WHERE [ID] = @Id
RETURN @@ERROR