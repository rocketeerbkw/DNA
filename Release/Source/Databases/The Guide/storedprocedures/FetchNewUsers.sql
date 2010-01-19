/*
Fetchs all active users that were registered within the specified number
of time units from the current date/time. The default time unit is days, but
different time units can be specified . Valid values and appreviations for
the datepart are:

	UNIT		ABBREVIATION
	----		------------
	year		yy, yyyy
	quarter		qq, q
	month		mm, m
	dayofyear	dy, y
	day			dd, d
	week		wk, ww
	hour		hh
	minute		mi, n
	second		ss, s
	millisecond	ms

Currently however the only values supported by the case statement are year,
month, week, day and hour.
*/


create procedure fetchnewusers
					@numberofunits int,
					@unittype varchar(16) = 'day',
					@filterusers bit = 0,
					@filtertype varchar(30) = '',
					@siteid int,	-- used to have a default value
					@showupdatingusers int,
					@skip INT =0, 
					@show INT =10000
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

set @show = @show + 1 -- add one

-- calculate the date after which user are counted as 'new'
declare @Date datetime
set @Date =	case
			when lower(@unittype) = 'year' then dateadd(year, -@numberofunits, getdate())
			when lower(@unittype) = 'month' then dateadd(month, -@numberofunits, getdate())
			when lower(@unittype) = 'week' then dateadd(week, -@numberofunits, getdate())
			when lower(@unittype) = 'day' then dateadd(day, -@numberofunits, getdate())
			when lower(@unittype) = 'hour' then dateadd(hour, -@numberofunits, getdate())
			else dateadd(week, -@numberofunits, getdate())
		end

if @numberofunits > 12
BEGIN
    SET @numberofunits = 12
END

-- then select all the relevant details for these users
IF @filterusers = 1
BEGIN
	IF @filtertype = 'haveintroduction'
	BEGIN
		IF @showupdatingusers = 1
		BEGIN
			;WITH newusers AS
			(
				SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
				FROM Users U
				inner join Mastheads m  on U.UserID = m.UserID AND m.SiteID = @siteid
				INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID AND GE.SiteID = @siteid
				inner join Preferences P  on P.UserID = U.UserID AND P.SiteID = @siteid
				where P.DateJoined > @Date  and U.active = 1 and 
				(@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid )) 
				and (LEN(GE.Subject)+ DATALENGTH(GE.text) > 0 )
			)
			select	nU.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, 'Journal' = J.ForumID, U.Active, P.Title, P.SiteSuffix, 'DateJoined' = GE.DateCreated, 'Masthead' = GE.h2g2id, GE.ForumID, GE.SiteID,
			"ForumPostedTo" =	
			case
				when EXISTS(select * from Threads T  where T.ForumID = GE.ForumID) 
				then 1
				else 0
			end from newusers nu 
			inner join Users U  on U.UserID = nU.UserID
			inner join Mastheads m  on nU.UserID = m.UserID AND m.SiteID = @siteid
			INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
			left outer join Preferences P  on (P.UserID = nU.UserID) and (P.SiteID = GE.SiteID)
			inner join Journals J  on J.UserID = nU.UserID and J.SiteID = GE.SiteID
			where n > @skip AND n <=(@skip+@show)
			
		END
		ELSE
		BEGIN
			;WITH newusers AS
			(
				SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
				FROM Users U
				inner join Preferences P  on (P.UserID = U.UserID)
				where P.DateJoined > @Date  and U.active = 1 and 
				(@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid )) 
			)
			select	nU.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, 'Journal' = J.ForumID, U.Active,  P.Title, P.SiteSuffix, 'DateJoined' = G.DateCreated, 'Masthead' = G.h2g2ID, G.ForumID, G.SiteID,
				'ForumPostedTo' =	
				case
					when EXISTS(select * from Threads T  
					where T.ForumID = G.ForumID) then 1
					else 0
				end
			from newusers nu 
			inner join Users U  on U.UserID = nU.UserID
			inner join mastheads m  on nU.userid = m.UserID AND m.SiteID = @siteid
			left outer join GuideEntries G  on m.EntryID = G.EntryID
			left outer join Preferences P  on (P.UserID = nU.UserID) and (P.SiteID = G.SiteID)
			inner join Journals J  on J.UserID = nU.UserID and J.SiteID = @siteid
			where n > @skip AND n <=(@skip+@show)
		END
	END
	ELSE
	BEGIN
		IF @showupdatingusers = 1
		BEGIN
			;WITH newusers AS
			(
				SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
				FROM Users U
				inner join Mastheads m  on U.UserID = m.UserID AND m.SiteID = @siteid
				INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
				inner join Preferences P  on (P.UserID = U.UserID)
				where P.DateJoined > @Date  and U.active = 1 and 
				(@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid )) 
				and (LEN(GE.Subject)+ DATALENGTH(GE.text) > 0 )
				and not EXISTS(select * from Threads T  where T.ForumID = GE.ForumID)
			)
			select	U.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, 'Journal' = J.ForumID, U.Active,  P.Title, P.SiteSuffix, 'DateJoined' = GE.DateCreated, 'Masthead' = GE.h2g2ID, GE.ForumID, GE.SiteID,
			"ForumPostedTo" =	
			case
				when EXISTS(select * from Threads T  where T.ForumID = GE.ForumID) 
				then 1
				else 0
			end from 
			newusers nu
			inner join Users U on U.userid=nU.userid
			JOIN Mastheads m  ON U.userid = m.UserID AND m.SiteID = @siteid
			INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
			left outer join Preferences P  on (P.UserID = U.UserID) and (P.SiteID = GE.SiteID)
			inner join Journals J  on J.UserID = U.UserID and J.SiteID = GE.SiteID	
			where n > @skip AND n <=(@skip+@show)				


		END
		ELSE
		BEGIN
			;WITH newusers AS
			(
				SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
				FROM Users U
				inner join Mastheads m  on U.UserID = m.UserID AND m.SiteID = @siteid
				INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
				inner join Preferences P  on (P.UserID = U.UserID)
				where P.DateJoined > @Date  and U.active = 1 
				and (@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid )) 
				and not EXISTS(select * from Threads T  where T.ForumID = GE.ForumID)
			)
			select	U.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, J.ForumID as 'Journal', U.Active,  P.Title, P.SiteSuffix, 'DateJoined' = G.DateCreated, 'Masthead' = G.h2g2ID, G.ForumID, G.SiteID,
			'ForumPostedTo' =
			case
				when EXISTS(select * from Threads T  
				where T.ForumID = G.ForumID) then 1
				else 0
			end
			from 			
			newusers nu
			inner join Users U on U.userid=nU.userid 
			JOIN Mastheads m  ON U.UserID = m.UserID AND m.SiteID = @siteid
			left outer join GuideEntries G  on m.EntryID = G.EntryID
			left outer join Preferences P  on (P.UserID = U.UserID) and (P.SiteID = G.SiteID)
			inner join Journals J  on J.UserID = U.UserID and J.SiteID = @siteid
			where n > @skip AND n <=(@skip+@show)	
		END
	END
END
ELSE
BEGIN
	IF @showupdatingusers = 1
	BEGIN
		
		;WITH newusers AS
		(
			SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
			FROM Users U
			inner join Mastheads m  on U.UserID = m.UserID AND m.SiteID = @siteid
			INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
			inner join Preferences P  on (P.UserID = U.UserID)
			where P.DateJoined > @Date  and U.active = 1 and 
			(@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid )) 
			and (LEN(GE.Subject)+ DATALENGTH(GE.text) > 0 )
		)
		select	U.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, 'Journal' = J.ForumID, U.Active,  
		P.Title, P.SiteSuffix, 'DateJoined' = GE.DateCreated, 'Masthead' = GE.h2g2ID, GE.ForumID, GE.SiteID,
		"ForumPostedTo" =	
		case
			when EXISTS(select * from Threads T  where T.ForumID = GE.ForumID) 
			then 1
			else 0
		end 
		from newusers nu
		inner join Users U on U.userid=nU.userid 
		JOIN Mastheads m  ON U.UserID = m.UserID AND m.SiteID = @siteid
		INNER JOIN  GuideEntries GE  ON m.EntryID = GE.EntryID
		inner join Preferences P  on (P.UserID = U.UserID) and (P.SiteID = GE.SiteID)
		inner join Journals J  on J.UserID = U.UserID and J.SiteID = GE.SiteID
		where  n > @skip AND n <=(@skip+@show)	

	END
	ELSE
	BEGIN
		;WITH newusers AS
		(
			SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
			FROM Users U
			inner join Preferences P on (P.UserID = U.UserID) and (P.SiteID = @siteid)
			where P.DateJoined> @Date and U.active = 1  and
				(@siteid = 0 or (P.SiteID IS NOT NULL AND P.SiteID = @siteid))
		)
		select	U.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, J.ForumID as 'Journal', U.Active,  P.Title, P.SiteSuffix, 'DateJoined' = G.DateCreated, 'Masthead' = G.h2g2ID, G.ForumID, G.SiteID,
			'ForumPostedTo' =	
			case
					when EXISTS(select * from Threads T  where T.ForumID = G.ForumID) then 1
					else 0
			end
		from 
		newusers nu
		inner join Users U on U.userid=nU.userid 
		JOIN Mastheads m  ON U.UserID = m.UserID AND m.SiteID = @Siteid
		left outer join GuideEntries G  on m.EntryID = G.EntryID
		left outer join Preferences P  on (P.UserID = U.UserID) and (P.SiteID = G.SiteID)
		inner join Journals J  on J.UserID = U.UserID and J.SiteID = @Siteid
		where  n > @skip AND n <=(@skip+@show)


	END
END



