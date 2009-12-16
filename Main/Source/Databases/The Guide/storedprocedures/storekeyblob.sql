Create Procedure storekeyblob	@blobname varchar(255), @blobid int, @activate datetime = NULL
As
	if @activate IS NULL
		SELECT @activate = getdate()
	INSERT INTO KeyBlobs (BlobName, BlobID, DateActive) VALUES (@blobname, @blobid, @activate)
	return (0)

