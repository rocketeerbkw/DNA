Create Procedure getdailylogs @startdate datetime
As
SELECT 'date' = 
	CASE 
	WHEN date1 IS NOT NULL 
		THEN date1 
	WHEN date2 IS NOT NULL
		THEN date2
	WHEN date3 IS NOT NULL
		THEN date3
		ELSE date4 
	END, 
	newusers, 
	newpages,
	pageviews,
	posts
FROM 
(
	select 
		'date1' = DATEADD(	minute, 
							10*(DATEDIFF(	minute,
											'28 apr 1999',
											LogDate)
										/ 10), '28 Apr 1999'), 
		'newusers' = COUNT(DISTINCT UserID) 
	FROM ActivityLog 
	WHERE LogDate >= @startdate 
		AND LogDate < DATEADD(day,1,@startdate) AND LogType = 'ACTI'
	group by DATEADD(	minute, 
						10*(
							DATEDIFF(	minute,
										'28 apr 1999',
										LogDate
									)/10
							), 
						'28 Apr 1999') 
) 
		as t
		FULL OUTER JOIN (select 'date2' = DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateCreated)/10), '28 Apr 1999'), 'newpages' = COUNT(EntryID) FROM GuideEntries WHERE DateCreated >= @startdate AND DateCreated < DATEADD(day,1,@startdate) group by DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateCreated)/10), '28 Apr 1999') ) as a ON date1 = date2
		FULL OUTER JOIN (select 'date3' = DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateViewed)/10), '28 Apr 1999'), 'pageviews' = COUNT(EntryID) FROM ArticleViews WHERE DateViewed >= @startdate AND DateViewed < DATEADD(day,1,@startdate) group by DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateViewed)/10), '28 Apr 1999') ) as v ON date3 = date2 OR date3 = date1
		FULL OUTER JOIN (select 'date4' = DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DatePosted)/10), '28 Apr 1999'), 'posts' = COUNT(EntryID) FROM ThreadEntries WHERE DatePosted >= @startdate AND DatePosted < DATEADD(day,1,@startdate) group by DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DatePosted)/10), '28 Apr 1999') ) as p ON date4 = date3 OR date4 = date2 OR date4 = date1

order by date

	return (0)