CREATE Procedure updatecategorydetails @nodeid int, @description varchar(1023), @name varchar(255)
As
	declare @catid int
	declare @catname varchar(255)

	SELECT @catid = CategoryID FROM Category WHERE UniqueName = @name
	SELECT @catname = UniqueName FROM Category WHERE CategoryID = @nodeid

	/* Only update if the new name doesn't exist - but check to see if you are just using the same name */
	IF ((@catid IS NULL) OR (@catname = @name))
	Begin
  	   UPDATE Category
		SET Description = @description, UniqueName = @name
		WHERE CategoryID = @nodeid

	   SELECT 'CategoryID' = @nodeid
	 END
 	ELSE
	 BEGIN
	   SELECT 'CategoryID' = NULL
  	 END

