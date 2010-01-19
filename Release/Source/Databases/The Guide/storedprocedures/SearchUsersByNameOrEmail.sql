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
				 @siteid int = 0
AS
DECLARE @LIKEvar varchar(256), @LIKEvar2 varchar(256), @email varchar(255)
SELECT @LIKEvar = @nameoremail + '%', @LIKEvar2 = '%' + @nameoremail + '%', @email = CASE WHEN @searchemails = 1 THEN @nameoremail ELSE '***' END

-- ensure sensible value for ScoreToBeat
IF (@scoretobeat IS NULL) SET @scoretobeat = 0.0
IF @siteid = 0
BEGIN
	SELECT U.*, 'Title' = NULL, 'SiteSuffix' = NULL,
				'Score' = CASE
					WHEN Email = @email THEN 1.0
					WHEN Username = @nameoremail THEN 0.9
					--WHEN FirstNames = @nameoremail OR LastName = @nameoremail THEN 0.75
					WHEN (--FirstNames LIKE @LIKEvar OR
					--LastName LIKE @LIKEvar OR
					Username LIKE @LIKEvar) THEN 0.5
					ELSE 0.1
					END
	FROM	Users U WITH(NOLOCK)
	WHERE	Status <> 0 AND 
			(Username LIKE @LIKEvar2 OR Email = @email) AND
			CASE
				WHEN Email = @email THEN 1.0
				WHEN Username = @nameoremail  THEN 0.9
				--	WHEN FirstNames =  @nameoremail or LastName = @nameoremail THEN 0.75
				WHEN (--FirstNames LIKE @LIKEvar or
				--LastName LIKE @LIKEvar or
				Username LIKE @LIKEvar) THEN 0.5
				ELSE 0.1
				END > @scoretobeat
	ORDER BY Score DESC, Username
END
ELSE
BEGIN
	SELECT U.*, p.SiteSuffix, p.Title,
				'Score' = CASE
				WHEN Email = @email THEN 1.0
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
			U.Email = @email) AND
			CASE
				WHEN U.Email = @email THEN 1.0
				WHEN U.Username = @nameoremail  THEN 0.9
				--	WHEN FirstNames = @nameoremail OR LastName = @nameoremail THEN 0.75
				WHEN (--FirstNames LIKE @LIKEvar OR
				--LastName LIKE @LIKEvar OR
				U.Username LIKE @LIKEvar) THEN 0.5
				ELSE 0.1
				END > @scoretobeat
	ORDER BY Score DESC, Username
END

