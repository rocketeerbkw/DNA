Create Procedure getmonthlylogs @startdate datetime
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
		'date1' = DATEADD(	day, 
							28*(DATEDIFF(	day,
											'28 apr 1999',
											LogDate)
										/ 28), '28 Apr 1999'), 
		'newusers' = COUNT(DISTINCT UserID) 
	FROM ActivityLog 
	WHERE LogDate >= @startdate 
		AND LogType = 'ACTI'
	group by DATEADD(	day, 
						28*(
							DATEDIFF(	day,
										'28 apr 1999',
										LogDate
									)/28
							), 
						'28 Apr 1999') 
) 
		as t
		FULL OUTER JOIN (select 'date2' = DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DateCreated)/28), '28 Apr 1999'), 'newpages' = COUNT(EntryID) FROM GuideEntries WHERE DateCreated >= @startdate group by DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DateCreated)/28), '28 Apr 1999') ) as a ON date1 = date2
		FULL OUTER JOIN (select 'date3' = DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DateViewed)/28), '28 Apr 1999'), 'pageviews' = COUNT(EntryID) FROM ArticleViews WHERE DateViewed >= @startdate  group by DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DateViewed)/28), '28 Apr 1999') ) as v ON date3 = date2 OR date3 = date1
		FULL OUTER JOIN (select 'date4' = DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DatePosted)/28), '28 Apr 1999'), 'posts' = COUNT(EntryID) FROM ThreadEntries WHERE DatePosted >= @startdate group by DATEADD(day, 28*(DATEDIFF(day,'28 apr 1999',DatePosted)/28), '28 Apr 1999') ) as p ON date4 = date3 OR date4 = date2 OR date4 = date1

order by date

	return (0)