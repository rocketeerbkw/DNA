Create Procedure createuser	@email varchar(255) = NULL, 
								@username varchar(255) = NULL,
								@password varchar(255) = NULL,
								@firstnames varchar(255) = NULL,
								@lastname varchar(255) = NULL,
								@masthead int = NULL,
								@active bit = 0,
								@status int = 1,
								@anonymous bit = 0
As
RAISERROR('createuser DEPRECATED',16,1)

-- DEPRECATED. This procedure is no longer used by DNA

/*
	All parameters are optional - set whichever you like by calling it thus:
	EXEC createuser @email='a@d.c', @anonymous = 1
	all other parameters will take default values
*/

/*
	INSERT INTO Users (	email, 
						UserName, 
						Password, 
						FirstNames, 
						LastName, 
						MastHead,
						Active, 
						Status,
						Anonymous
						)
				VALUES(	@email,
						@username,
						@password,
						@firstnames,
						@lastname,
						@masthead,
						@active,
						@status,
						@anonymous
						)
	declare @userid int
	SELECT @userid = @@IDENTITY
	SELECT				UserID,
						Cookie,
						email, 
						UserName, 
						Password, 
						FirstNames, 
						LastName, 
						MastHead,
						Active, 
						Status,
						Anonymous,
						Journal
	FROM Users WHERE UserID = @userid
*/
	return (0)