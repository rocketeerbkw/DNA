/*
	Very simple search for users by name or email that gives an exceedingly
	crude score.

	Also allows an optional specification of a score that must be exceeded
	and a maximum number of results to return.
	
	TODO: This score needs to be improved on at some point.
*/

CREATE PROCEDURE searchusersbynameoremail
				 @nameoremail varchar(255),
				 @scoretobeat real = 0.0,
				 @searchemails int = 0,
				 @siteid int = 0,
				 @skip int = 0,
				 @show int = 100000
AS
DECLARE @LIKEvar varchar(256), @LIKEvar2 varchar(256), @email varchar(255)
SELECT @LIKEvar = @nameoremail + '%', @LIKEvar2 = '%' + @nameoremail + '%', @email = CASE WHEN @searchemails = 1 THEN @nameoremail ELSE '***' END

EXEC openemailaddresskey

DECLARE @hashedemail varbinary(900)
SET @hashedemail=dbo.udf_hashemailaddress(@email)

-- ensure sensible value for ScoreToBeat
IF (@scoretobeat IS NULL) SET @scoretobeat = 0.0;
IF @siteid = 0
BEGIN
	WITH CTE_Users_Site0 AS
	(
		SELECT U.*, 'Title' = NULL, 'SiteSuffix' = NULL,
					'Score' = CASE
						WHEN HashedEmail = @hashedemail THEN 1.0
						WHEN Username = @nameoremail THEN 0.9
						--WHEN FirstNames = @nameoremail OR LastName = @nameoremail THEN 0.75
						WHEN (--FirstNames LIKE @LIKEvar OR
						--LastName LIKE @LIKEvar OR
						Username LIKE @LIKEvar) THEN 0.5
						ELSE 0.1
						END
		FROM	Users U WITH(NOLOCK)
		WHERE	Status <> 0 AND 
				(Username LIKE @LIKEvar2 OR HashedEmail = @hashedemail) AND
				CASE
					WHEN HashedEmail = @hashedemail THEN 1.0
					WHEN Username = @nameoremail  THEN 0.9
					--	WHEN FirstNames =  @nameoremail or LastName = @nameoremail THEN 0.75
					WHEN (--FirstNames LIKE @LIKEvar or
					--LastName LIKE @LIKEvar or
					Username LIKE @LIKEvar) THEN 0.5
					ELSE 0.1
					END > @scoretobeat
	),
	UsersPagination0 AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY u0.Score DESC, u0.Username) AS 'n', u0.*
		FROM CTE_Users_Site0 u0
	)
	SELECT  'Count' = (select count(*) FROM CTE_Users_Site0), up0.*
	FROM UsersPagination0 up0
	WHERE up0.n > @skip AND up0.n <= @skip + @show
	ORDER BY n
	
END
ELSE
BEGIN
	WITH CTE_Users_SiteX AS
	(
		SELECT U.*, p.SiteSuffix, p.Title,
					'Score' = CASE
					WHEN HashedEmail = @hashedemail THEN 1.0
					WHEN Username = @nameoremail THEN 0.9
					--WHEN FirstNames = @nameoremail or LastName = @nameoremail THEN 0.75
					WHEN (--FirstNames LIKE @LIKEvar or
					--LastName LIKE @LIKEvar or
					Username LIKE @LIKEvar) THEN 0.5
					ELSE 0.1
					END
		FROM	Users U WITH(NOLOCK)
		INNER JOIN UserTeams ut on ut.UserID = u.UserID AND ut.SiteID = @siteid
		INNER JOIN Teams t WITH(NOLOCK) ON ut.TeamID = t.TeamID
		INNER JOIN Forums f WITH(NOLOCK) ON f.ForumID = t.ForumID
		LEFT JOIN Preferences p WITH(NOLOCK) ON (p.UserID = U.UserID) AND (p.SiteID = @siteid)
		WHERE	f.SiteID = @siteid AND
				U.Status <> 0 AND 
				(U.Username LIKE @LIKEvar2 OR
				U.HashedEmail = @hashedemail) AND
				CASE
					WHEN U.HashedEmail = @hashedemail THEN 1.0
					WHEN U.Username = @nameoremail  THEN 0.9
					--	WHEN FirstNames = @nameoremail OR LastName = @nameoremail THEN 0.75
					WHEN (--FirstNames LIKE @LIKEvar OR
					--LastName LIKE @LIKEvar OR
					U.Username LIKE @LIKEvar) THEN 0.5
					ELSE 0.1
					END > @scoretobeat
	),
	UsersPaginationX AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY uX.Score DESC, uX.Username) AS 'n', uX.*
		FROM CTE_Users_SiteX uX
	)
	SELECT  'Total' = (select count(*) FROM CTE_Users_SiteX), upX.*
	FROM UsersPaginationX upX
	WHERE upX.n > @skip AND upX.n <= @skip + @show
	ORDER BY n
END

