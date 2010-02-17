-- Adult sites
DECLARE @setup int
SET @Setup = 1

IF ( @Setup > 0 )
BEGIN
	update sites set indentitypolicy = 'http://identity/policies/dna/adult' where urlname in
	(
		'1xtra',
		'mb6music',
		'mbasiannetwork',
		'mbbbc7',
		'mbradio1',
		'mbradio2',
		'mbradio3',
		'mbradio4',
		'mbarchers',
		'mbcbeebies',
		'irish',
		'mbni',
		'mbtalkwales',
		'mbwalesedu',
		'mbfood',
		'mbgardening',
		'mbhistory',
		'mbouch',
		'mbparents',
		'mbpointsofview',
		'mbreligion',
		'mbheroes',
		'mbsn',
		'mble',
		'606',
		'h2g2',
		'hub',
		'moderation',
		'memoryshare',
		'mb16',
		'mbonionstreet',
		'mbtalkscot',
		'bonekickers',
		'theoneandonly',
		'apprentice',
		'thewall',
		'mbmovies',
		'mbsw',
		'mbtms',
		'mbarts',
		'dannywallace',
		'whatwedo',
		'eurovision',
		'mbweather',
		'mbhealth',
		'mbtoday',
		'mbholiday',
		'england',
		'mbimp',
		'c6music',
		'mbbbcmemories',
		'mbfivelive',
		'mb606',
		'mblifestyle',
		'mbscrumv'
	)

	-- Inert new siteoptions for each sit
	INSERT INTO siteoptions SELECT Section = 'SignIn', SiteID = sc.siteid, Name = 'UseIdentitySignIn', Value = 0
	FROM
	(
		SELECT siteid from sites s
		where s.urlname in
		(
			'1xtra',
			'mb6music',
			'mbasiannetwork',
			'mbbbc7',
			'mbradio1',
			'mbradio2',
			'mbradio3',
			'mbradio4',
			'mbarchers',
			'mbcbeebies',
			'irish',
			'mbni',
			'mbtalkwales',
			'mbwalesedu',
			'mbfood',
			'mbgardening',
			'mbhistory',
			'mbouch',
			'mbparents',
			'mbpointsofview',
			'mbreligion',
			'mble',
			'606',
			'h2g2',
			'hub',
			'moderation',
			'mbsn',
			'mbheroes',
			'memoryshare',
			'mb16',
			'mbonionstreet',
			'mbtalkscot',
			'bonekickers',
			'theoneandonly',
			'apprentice',
			'thewall',
			'mbmovies',
			'mbsw',
			'mbtms',
			'mbarts',
			'dannywallace',
			'whatwedo',
			'eurovision',
			'mbweather',
			'mbhealth',
			'mbtoday',
			'mbholiday',
			'england',
			'mbimp',
			'c6music',
			'mbbbcmemories',
			'mbfivelive',
			'mb606',
			'mblifestyle',
			'mbscrumv'
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
				'1xtra',
				'mb6music',
				'mbasiannetwork',
				'mbbbc7',
				'mbradio1',
				'mbradio2',
				'mbradio3',
				'mbradio4',
				'mbarchers',
				'irish',
				'mbni',
				'mbtalkwales',
				'mbwalesedu',
				'mbfood',
				'mbgardening',
				'mbhistory',
				'mbouch',
				'mbparents',
				'mbpointsofview',
				'mbreligion',
				'mble',
				'mb16',
				'mbonionstreet',
				'mbtalkscot',
				'bonekickers',
				'theoneandonly',
				'apprentice',
				'thewall',
				'mbmovies',
				'mbsw',
				'mbtms',
				'mbarts',
				'dannywallace',
				'whatwedo',
				'eurovision',
				'mbweather',
				'mbhealth',
				'mbtoday',
				'mbholiday',
				'england',
				'mbimp',
				'c6music',
				'mbbbcmemories',
				'mbfivelive',
				'mb606',
				'mblifestyle',
				'mbscrumv',
				'mbsn'
				/* These three are to move in Jan
				,'mbcbeebies',
				'mbheroes',
				'memoryshare',
				'606',
				'h2g2',
				'hub',
				'moderation'
				*/
			)
		)
END