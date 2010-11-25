DECLARE @SiteURL varchar(50)

/*	INSERT THE URL OF THE SITE YOU WANT TO CREATE THE SCRIPT FROM HERE  */
SELECT @SiteURL = ''


SELECT '
IF (NOT EXISTS ( SELECT * FROM Sites WHERE UrlName = ''' + urlname + ''' ))
BEGIN
	EXEC dbo.CreateNewSite ''' + urlname + ''', ''' + REPLACE(shortname,'''','''''') + ''', ''' + REPLACE(s.description,'''','''''') + ''', ''' + defaultskin + ''', '''
		+ defaultskin + ''', ''' + skinset + ''', 0, ' + cast(premoderation as varchar) + ', ' + cast(noautoswitch as varchar) + ', 0, '''
		+ moderatorsemail + ''', ''' + editorsemail + ''', ''' + feedbackemail + ''', ' + cast(automessageuserid as varchar) + ', '
		+ cast(passworded as varchar) + ', ' + cast(unmoderated as varchar) + ', ' + cast(ISNULL(articleforumstyle, '0') as varchar) + ', ' + cast(threadorder as varchar)
		+ ', ' + cast(threadedittimelimit as varchar) + ', ''' + eventemailsubject + ''', ' + cast(eventalertmessageuserid as varchar) + ', ' + cast(includecrumbtrail as varchar)
		+ ', ' + cast(ISNULL(allowpostcodesinsearch, 0) as varchar) + ', ''' + ssoservice + ''', 0, 1, 0, ' + cast(modclassid as varchar) + ', ''' + identitypolicy + '''
END
' as SQL
FROM Sites s where urlname = @SiteURL

SELECT '
DECLARE @SiteID INT
SELECT @SiteID = siteid from Sites WHERE URLName = ''' + @SiteURL + '''
IF (NOT EXISTS ( SELECT * FROM SiteOptions WHERE Section = ''' + so.Section + ''' AND SiteID = @SiteID AND Name = ''' + so.Name + '''))
BEGIN
	INSERT INTO SiteOptions SELECT Section = ''' + so.Section + ''', SiteID = @SiteID, Name = ''' + so.Name + ''', Value = ''' + so.Value + ''', Type = ' + cast(so.Type as varchar) + ', Description = ''' + REPLACE(so.Description,'''','''''') + '''
END
' as SQL
FROM Siteoptions so
INNER JOIN SItes s on s.siteid = so.siteid
WHERE s.urlname = @SiteURL

