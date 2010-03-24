CREATE PROCEDURE fetchsitedata @siteid int = NULL
As
DECLARE @DefaultUseIdentitySignIn VARCHAR(10), @DefaultIsKidsSite VARCHAR(10)
SELECT @DefaultUseIdentitySignIn = Value FROM SiteOptions WHERE SiteID = 0 AND [Section] = 'SignIn' AND [Name] = 'UseIdentitySignIn'
SELECT @DefaultIsKidsSite = Value FROM SiteOptions WHERE SiteID = 0 AND [Section] = 'General' AND [Name] = 'IsKidsSite'

SELECT	s.*,
		p.AgreedTerms,
		k.SkinName,
		'SkinDescription' = k.Description,
		k.UseFrames,
		dp.*,
		'UseIdentitySignIn' = CAST (ISNULL(so.Value,@DefaultUseIdentitySignIn) AS TinyInt),
		'IsKidsSite' = CAST (ISNULL(so2.Value,@DefaultIsKidsSite) AS TinyInt)
	FROM Sites s 
	INNER JOIN SiteSkins k ON s.SiteID = k.SiteID
	INNER JOIN Preferences p ON s.SiteID = p.SiteID AND p.UserID = 0
	INNER JOIN DefaultPermissions dp ON s.SiteID = dp.SiteID
	LEFT JOIN SiteOptions so ON so.SiteID = s.SIteID AND so.Section = 'SignIn' AND so.Name = 'UseIdentitySignIn'
	LEFT JOIN SiteOptions so2 ON so2.SiteID = s.SIteID AND so2.Section = 'General' AND so2.Name = 'IsKidsSite'
	WHERE s.SiteID = @siteid OR @siteid IS NULL
ORDER BY s.SiteID