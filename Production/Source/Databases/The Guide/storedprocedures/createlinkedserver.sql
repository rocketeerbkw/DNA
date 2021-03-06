create PROCEDURE createlinkedserver
	@server nvarchar(255),
	@database nvarchar(255),
	@db_user varchar(100),
	@db_user_password varchar(100)
AS


	EXEC sp_addlinkedserver
		@server = @server,
		@srvproduct = '',
		@provider = 'SQLNCLI',
		@datasrc = @server,
		@catalog = @database
		
	EXEC sp_serveroption @server=@server, @optname = 'rpc', @optvalue='true'
	EXEC sp_serveroption @server=@server, @optname='rpc out', @optvalue='true' 	

	EXEC sp_addlinkedsrvlogin @server, 'false', NULL, @db_user, @db_user_password

	RETURN 0;
