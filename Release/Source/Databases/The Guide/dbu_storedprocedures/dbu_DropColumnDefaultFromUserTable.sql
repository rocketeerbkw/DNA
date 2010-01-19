CREATE PROCEDURE dbu_dropcolumndefaultfromusertable @table varchar(255), @column varchar(255), @errornum INT OUTPUT
AS
	/* Drop column's default constraint */
	DECLARE @DefaultName NVARCHAR(255)
	DECLARE @DropConstraintQuery NVARCHAR(510)
	
	-- Get column's default constraint name. 
	SELECT @DefaultName = dft.name
	  FROM sysobjects tbl
		   INNER JOIN syscolumns col ON col.id = tbl.id
		   INNER JOIN sysobjects dft ON dft.id = col.cdefault
	 WHERE tbl.name = @table
	   AND tbl.type = 'U'
	   AND col.name = @column

	IF (@DefaultName IS NOT NULL)
	BEGIN
		-- Drop column's default constraint name. 
		SELECT @DropConstraintQuery = 'ALTER TABLE ' + @table + ' DROP CONSTRAINT ' + @DefaultName

		EXECUTE dbu_dosql @sql 					= @DropConstraintQuery, 
						  @actiondescription 	= @DropConstraintQuery,
						  @errornum				= @errornum OUTPUT

	END 

RETURN 0 

