CREATE PROCEDURE getmoderateditemspermoderator @startdate datetime, @enddate datetime
AS
	/*
		Function: Gets counts of moderation decisions by moderators grouped by month

		Params:
			@startdate - start of range. 
			@enddate - end of range. 

		Results Set:	UserName			VARCHAR(255)
						UserID				INT
						mname				VARCHAR(10)
						totalposts			INT
						totalarticles		INT
						totalcomplaints		INT
						totalreferrals		INT

		Returns: @@ERROR
	*/

	select u.UserName, st.UserID, st.yr, st.mname, st.totalposts, st.totalarticles,st.totalcomplaints, st.totalreferrals
	from (
			select	case 
						when tm.LockedBy IS NOT NULL THEN tm.LockedBy
						when am.LockedBy IS NOT NULL THEN am.LockedBy
						when cm.LockedBy IS NOT NULL THEN cm.LockedBy
						when rf.LockedBy IS NOT NULL THEN rf.LockedBy
						ELSE NULL
					END as UserID,
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
					select	LockedBy, 
							DATEPART(year, DateCompleted) as yr,
							DATEPART(month, DateCompleted) as monthnum, 
							DATENAME(month,DateCompleted) as monthname, 
							COUNT(*) as totalposts 
					from threadmod t
					where LockedBy IS NOT NULL 
					and t.datecompleted >= @startdate
					and t.datecompleted < @enddate
					And ComplainantID IS NULL
					group by LockedBy, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)
				) tm

			full outer join (
								select	LockedBy, 
										DATEPART(year, DateCompleted) as yr,
										DATEPART(month, DateCompleted) as monthnum, 
										DATENAME(month,DateCompleted) as monthname, 
										COUNT(*) as totalarticles 
								from ArticleMod t
								where LockedBy IS NOT NULL 
								and t.datecompleted >= @startdate
								and t.datecompleted < @enddate
								group by LockedBy, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)
							) am on tm.LockedBy = am.LockedBy and tm.monthnum = am.monthnum

			full outer join (
								select	LockedBy, 
										DATEPART(year, DateCompleted) as yr,
										DATEPART(month, DateCompleted) as monthnum, 
										DATENAME(month,DateCompleted) as monthname, 
										COUNT(*) as totalcomplaints 
								from ThreadMod t
								where LockedBy IS NOT NULL 
								and t.datecompleted >= @startdate
								and t.datecompleted < @enddate
								AND t.ComplainantID IS NOT NULL
								group by LockedBy, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)
							) cm on (cm.LockedBy = am.LockedBy or cm.LockedBy = tm.LockedBy) and (cm.monthnum = am.monthnum or cm.monthnum = tm.monthnum)

			full outer join (
								select ReferredBy as LockedBy, 
										DATEPART(year, DateCompleted) as yr,
										DATEPART(month, DateCompleted) as monthnum, 
										DATENAME(month,DateCompleted) as monthname, 
										COUNT(*) as totalreferrals 
								from ThreadMod t
								where ReferredBy IS NOT NULL 
								and t.datecompleted >= @startdate
								and t.datecompleted < @enddate
								group by ReferredBy, DATEPART(year, DateCompleted), DATEPART(month, DateCompleted), DATENAME(month,DateCompleted)
							) rf on (rf.LockedBy = am.LockedBy or rf.LockedBy = tm.LockedBy) and (rf.monthnum = am.monthnum or rf.monthnum = tm.monthnum)

		) st
		join users u on u.UserID = st.UserID
		order by st.UserID, st.yr, st.mn

RETURN @@ERROR
-- getmoderateditemspermoderator @startdate = '2007-01-01', @enddate = '2008-03-19'