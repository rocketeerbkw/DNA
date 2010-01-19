/*********************************************************************************

	create procedure getrestricteduserlist	@viewinguserid int, 
											@skip int, 
											@show int, 
											@usertypes int, 
											@siteid int 

	Author:		Steven Francis
	Created:	06/11/2007
	Inputs:		@viewinguserid int	- the viewer looking at the list, 
				@skip int			- number of users to skip , 
				@show int			- number to show, 
				@usertypes int		- which types of restricted user to show, 
				@siteid int			- the site id to restrict to, 
	Outputs:	
	Returns:	Restricted Users dataset
	Purpose:	Gets the restricted users requested
*********************************************************************************/
CREATE PROCEDURE getrestricteduserlist @viewinguserid int, @skip int, @show int, @usertypes int, @siteid int
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @sql nvarchar(max)
	
	DECLARE @EditorGroupID int
	-- Get the Editor group id from the groups table
	SELECT @EditorGroupID = GroupID FROM Groups WHERE Name = 'Editor';
	
	SELECT @sql = N'
			WITH RestrictedUsersCTE AS
			(	
				SELECT (ROW_NUMBER() OVER (ORDER BY PrefStatusChangedDate desc) - 1) AS ''Row'', 
					u.UserID,
					u.UserName, 
					u.FirstNames, 
					u.LastName, 
					u.Status, 
					u.Active, 
					u.Postcode, 
					u.Area, 
					u.TaxonomyNode, 
					u.UnreadPublicMessageCount, 
					u.UnreadPrivateMessageCount, 
					u.Region, 
					u.HideLocation, 
					u.HideUserName, 
					u.LoginName,
					u.Email,
					p.PrefStatus,
					us.UserStatusDescription,
					ISNULL(p.PrefStatusDuration,0) As PrefStatusDuration,
					p.PrefStatusChangedDate,
					p.SiteID,
					s.ShortName,
					s.urlname
				FROM Users u WITH(NOLOCK)
				INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID
				INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID
				INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID
				INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus
				INNER JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = @viewinguserid AND g.GroupID = @EditorGroupID AND g.SiteID = s.SiteID 
				WHERE '

	IF (@siteid <> 0)
	BEGIN
		SELECT @sql = @sql + N' p.SiteID = @siteid AND '
	END
	
	IF (@usertypes <> 0)
	BEGIN
		SELECT @sql = @sql + N' p.PrefStatus = @usertypes '
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N' (p.PrefStatus = 1 OR p.PrefStatus = 4) '
	END
	
	SELECT @sql = @sql + N' )
							SELECT (SELECT COUNT(*) FROM RestrictedUsersCTE) ''total'', * 
							FROM RestrictedUsersCTE ru
							WHERE ru.Row BETWEEN @skip AND (@skip + @show - 1)
							ORDER BY ru.Row'
	
	--SELECT @sql
		
	EXECUTE sp_executesql @sql, 
							N'@viewinguserid int,
							@EditorGroupID int,
							@usertypes int,
							@skip int,
							@show int,
							@siteid int',
							@viewinguserid = @viewinguserid, 
							@EditorGroupID = @EditorGroupID, 
							@usertypes = @usertypes, 
							@skip = @skip, 
							@show = @show, 
							@siteid = @siteid