-- Over 13s
DECLARE @setup int
SET @Setup = 1

IF ( @Setup > 0 )
BEGIN
	update sites set identitypolicy = 'http://identity/policies/dna/over13' where urlname in
	(
		'mbgcsebitesize'
	)

	-- Inert new siteoptions for each sit
	INSERT INTO siteoptions SELECT Section = 'SignIn', SiteID = sc.siteid, Name = 'UseIdentitySignIn', Value = 0, Type = 1, Description = 'Set this option to ON if you want to use Identity as the Sign In System. OFF will fallback to using the SSO system.'
	FROM
	(
		SELECT siteid from sites s
		where s.urlname in
		(
			'mbgcsebitesize'
		)
		and s.Siteid NOT in
		(
			-- Don't include sites that already have a siteoption set
			SELECT SiteID FROM siteoptions WHERE Section = 'SignIn' and Name = 'UseIdentitySignIn' and siteid != 0
		)
	) as sc
END
ELSE
BEGIN
	-- Set the identity siteoption for adult sites
	UPDATE siteoptions SET Value = 1
	WHERE
		Section = 'SignIn'
		AND Name = 'UseIdentitySignIn'
		AND SiteID IN
		(
			SELECT siteid from sites s
			where s.urlname in
			(
				'mbgcsebitesize'
			)
		)
END