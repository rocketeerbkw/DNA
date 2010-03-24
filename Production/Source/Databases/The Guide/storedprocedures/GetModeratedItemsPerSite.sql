CREATE PROCEDURE getmoderateditemspersite @startdate datetime, @enddate datetime
AS
	/*
		Function: Gets counts of moderation items grouped by site. 

		Params:
			@startdate - start of range. 
			@enddate - end of range. 

		Results Set: 	urlname			varchar(30) - Site's urlname
						SiteID			int			- Site's ID
						mname			varchar(10) - month nane
						totalposts		int			- number of posts moderated excluding complaints
						totalarticles	int			- number of articles moderated 
						totalcomplaints int			- number of complaints on posts moderated
						totalreferrals	int			- number of referrals

		Returns: @@ERROR
	*/

	select s.urlname, st.SiteID, st.yr, st.mname, st.totalposts, st.totalarticles,st.totalcomplaints, st.totalreferrals
	from	(
				select case 
							when tm.SiteID IS NOT NULL THEN tm.SiteID
							when am.SiteID IS NOT NULL THEN am.SiteID
							when cm.SiteID IS NOT NULL THEN cm.SiteID
							when rf.SiteID IS NOT NULL THEN rf.SiteID
							ELSE NULL
						END as SiteID,
						case 
							when tm.yr IS NOT NULL THEN tm.yr
							when am.yr IS NOT NULL THEN am.yr
							when cm.yr IS NOT NULL THEN cm.yr
							when rf.yr IS NOT NULL THEN rf.yr
							ELSE NULL
						END as yr,
						case 
							when tm.monthnum IS NOT NULL THEN tm.monthnum
							when am.monthnum IS NOT NULL THEN am.monthnum
							when cm.monthnum IS NOT NULL THEN cm.monthnum
							when rf.monthnum IS NOT NULL THEN rf.monthnum
							ELSE NULL
						END as mn,
						case 
							when tm.monthname IS NOT NULL THEN tm.monthname
							when am.monthname IS NOT NULL THEN am.monthname
							when cm.monthname IS NOT NULL THEN cm.monthname
							when rf.monthname IS NOT NULL THEN rf.monthname
							ELSE NULL
						END as mname,
						ISNULL(totalposts,0) as totalposts,
						ISNULL(totalarticles,0) as totalarticles,
						ISNULL(totalcomplaints,0) as totalcomplaints,
						ISNULL(totalreferrals,0) as totalreferrals
				from (
						select SiteID, 
								DATEPART(year, DateCompleted) as yr,
								DATEPART(month, DateCompleted) as monthnum, 
								DATENAME(month,DateCompleted) as monthname, 
								COUNT(*) as totalposts -- number of posts moderated excluding complaints
						from threadmod t
						where t.datecompleted >= @startdate 
						and t.datecompleted < @enddate
						And ComplainantID IS NULL
						group by SiteID, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)) tm

						full outer join (
											select SiteID, 
													DATEPART(year, DateCompleted) as yr,
													DATEPART(month, DateCompleted) as monthnum, 
													DATENAME(month,DateCompleted) as monthname, 
													COUNT(*) as totalarticles 
											from ArticleMod t
											where t.datecompleted >= @startdate 
											and t.datecompleted < @enddate
											group by SiteID, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)) am on tm.SiteID = am.SiteID and tm.monthnum = am.monthnum and tm.yr = am.yr

						full outer join (
											select SiteID, 
													DATEPART(year, DateCompleted) as yr,
													DATEPART(month, DateCompleted) as monthnum, 
													DATENAME(month,DateCompleted) as monthname, 
													COUNT(*) as totalcomplaints 
											from ThreadMod t
											where t.datecompleted >= @startdate 
											and t.datecompleted < @enddate
											AND t.ComplainantID IS NOT NULL
											group by SiteID, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)) cm on (cm.SiteID = am.SiteID or cm.SiteID = tm.SiteID) and (cm.monthnum = am.monthnum or cm.monthnum = tm.monthnum) and (cm.yr = am.yr or cm.yr = tm.yr)

						full outer join (
											select SiteID, 
													DATEPART(year, DateCompleted) as yr,
													DATEPART(month, DateCompleted) as monthnum, 
													DATENAME(month,DateCompleted) as monthname, 
													COUNT(*) as totalreferrals 
											from ThreadMod t
											where t.datecompleted >= @startdate 
											and t.datecompleted < @enddate
											and ReferredBy IS NOT NULL
											group by SiteID, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)) rf on (rf.SiteID = am.SiteID or rf.SiteID = tm.SiteID) and (rf.monthnum = am.monthnum or rf.monthnum = tm.monthnum) and (rf.yr = am.yr or rf.yr = tm.yr)

				) st 
				join sites s on s.SiteID = st.SiteID
				order by st.SiteID, st.yr, st.mn

RETURN @@ERROR

-- getmoderateditemspersite @startdate = '1 apr 2007', @enddate = '20 mar 2008'