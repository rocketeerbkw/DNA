CREATE FUNCTION udf_indexcontainsfield(@tablename varchar(255), @indexname varchar(255), @fieldname varchar(255))
RETURNS INT
AS
BEGIN
	IF NOT EXISTS (select
k.id,k.indid, k.colid, o.name,i.name, c.name from sysindexkeys k join sysobjects o on o.id = k.id
join sysindexes i on k.id = i.id and k.indid = i.indid
join syscolumns c on k.colid = c.colid and k.id = c.id
where o.name = @tablename AND i.name = @indexname AND c.name = @fieldname)

	BEGIN
		RETURN 0
	END
RETURN 1	
END
