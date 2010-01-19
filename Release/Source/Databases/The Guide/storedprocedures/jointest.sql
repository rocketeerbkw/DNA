Create Procedure jointest
As
declare @startdate datetime
SELECT @startdate = '25 May 1999'
(
SELECT 'date' = 
	CASE 
	WHEN date1 IS NOT NULL 
		THEN date1 
	WHEN date2 IS NOT NULL
		THEN date2
		ELSE date3 
	END, 
	newusers, 
	newpages,
	pageviews
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
		AND LogDate < DATEADD(day,1,@startdate) 
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
)
order by date
/*
FULL OUTER JOIN (select 'date3' = DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateViewed)/10), '28 Apr 1999'), 'pageviews' = COUNT(EntryID) FROM ArticleViews WHERE DateViewed >= @startdate AND DateViewed < DATEADD(day,1,@startdate) group by DATEADD(minute, 10*(DATEDIFF(minute,'28 apr 1999',DateViewed)/10), '28 Apr 1999') ) as v ON t.date = v.date3
*/
	return (0)