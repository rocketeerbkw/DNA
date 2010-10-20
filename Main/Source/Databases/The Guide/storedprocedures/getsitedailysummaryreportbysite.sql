create PROCEDURE getsitedailysummaryreportbysite
@startdate datetime =null,
@enddate datetime =null,
@siteid int =0

AS


if @startdate is null
begin
	set @startdate = dbo.udf_dateonly(dateadd(d, -1, getdate()))
end

if @enddate is null
begin
	set @enddate = dbo.udf_dateonly(dateadd(d, 1, @startdate))
end 
else
begin
	set @enddate = dbo.udf_dateonly(dateadd(d, 1, @enddate))
end


SELECT 
      sum(TotalModerations) as TotalModerations,
      sum(TotalReferredModerations) as TotalReferredModerations,
      sum(TotalComplaints) as TotalComplaints,
      sum(UniqueModerationUsers) as UniqueModerationUsers,
      sum(TotalNotablePosts) as TotalNotablePosts,
      sum(TotalHostPosts) as TotalHostPosts,
      sum(TotalPosts) as TotalPosts,
      sum(TotalExLinkModerations) as TotalExLinkModerations,
      sum(TotalExLinkReferrals) as TotalExLinkReferrals,
      sum(TotalExLinkModPasses) as TotalExLinkModPasses,
      sum(TotalExLinkModFails) as TotalExLinkModFails,
      sum(TotalPostsFailed) as TotalPostsFailed,
      sum(TotalNewUsers) as TotalNewUsers,
      sum(TotallBannedUsers) as TotalBannedUsers,
      sum(TotalNickNamesModerations) as TotalNickNamesModerations
 FROM dbo.SiteDailySummaryReport sdsr
 inner join sites s on s.siteid = sdsr.siteid
 where
	(@siteid=0 or s.siteid=@siteid) and
	sdsr.Date >= @startdate and sdsr.date < @enddate
	
