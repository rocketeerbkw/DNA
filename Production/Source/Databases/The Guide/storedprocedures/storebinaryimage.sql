CREATE Procedure storebinaryimage	@blobid int,
										@mimetype varchar(255),
										@server varchar(255),
										@path varchar(255),
										@name varchar(255),
										@desc varchar(255)
As
	UPDATE blobs SET mimetype = @mimetype, ServerName = @server, Path = @path, Name = @name, Description = @desc
		WHERE blobid = @blobid
	return (0)

