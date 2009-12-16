CREATE PROCEDURE getacceptedentries @siteid int = 1
As
select g.Subject, g.h2g2ID, g.EntryID, 'GuideStatus' = g.Status,
		'AcceptedStatus' =  a.Status,
		'OriginalEntryID' = g1.EntryID,
		'Originalh2g2ID' = g1.h2g2ID,
		a.SubEditorID, 
		'SubEditorName'			= sub.UserName,
		'SubeditorFirstNames'	= sub.FirstNames,
		'SubeditorLastName'		= sub.LastName,
		'SubeditorArea'			= sub.Area,
		'SubeditorStatus'		= sub.Status,
		'SubeditorTaxonomyNode'	= sub.TaxonomyNode,
		'SubeditorJournal'		= sub.Journal,
		'SubeditorActive'		= sub.Active,
		'SubeditorSiteSuffix'	= subPrefs.SiteSuffix,
		'SubeditorTitle'		= subPrefs.Title,
		'ScoutID'			= a.AcceptorID, 
		'ScoutName'			= sc.UserName,
		'ScoutFirstNames'	= sc.FirstNames,
		'ScoutLastName'		= sc.LastName,
		'ScoutArea'			= sc.Area,
		'ScoutStatus'		= sc.Status,
		'ScoutTaxonomyNode'	= sc.TaxonomyNode,
		'ScoutJournal'		= sc.Journal,
		'ScoutActive'		= sc.Active,
		'ScoutSiteSuffix'	= scPrefs.SiteSuffix,
		'ScoutTitle'		= scPrefs.Title,
		a.DateAllocated, a.DateReturned
		 from GuideEntries g
INNER JOIN AcceptedRecommendations a 
ON a.EntryID = g.EntryID
INNER JOIN AcceptedRecommendationStatus s ON a.Status = s.Status
INNER JOIN GuideEntries g1 ON a.OriginalEntryID = g1.EntryID
INNER JOIN Users sc ON sc.UserID = a.AcceptorID
LEFT JOIN Preferences scPrefs ON scPrefs.UserID = sc.UserID AND scPrefs.SiteID = @siteid
LEFT JOIN Users sub ON sub.UserID = a.SubEditorID
LEFT JOIN Preferences subPrefs ON subPrefs.UserID = sub.UserID AND subPrefs.SiteID = @siteid
INNER JOIN Journals J ON J.UserID = sc.UserID and J.SiteID = @siteid
LEFT JOIN Journals J1 ON J1.UserID = sub.UserID and J1.SiteID = @siteid
WHERE g.Status <> 1 AND g.SiteID = @siteid
ORDER BY a.Status, a.DateAllocated