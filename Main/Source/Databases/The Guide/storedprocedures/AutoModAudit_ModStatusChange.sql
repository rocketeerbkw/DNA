CREATE PROCEDURE automodaudit_modstatuschange @modstatus int, @startdate datetime, @enddate datetime, @skip int, @show int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH UserAudit AS
(
	SELECT auditdate,auditid,ROW_NUMBER() OVER(ORDER BY auditdate DESC,auditid DESC) n
	FROM dbo.automodaudit ama
	WHERE modstatus=@modstatus AND reasonid=4
	AND auditdate BETWEEN @startdate AND @enddate
)
SELECT	ama.UserID,
		ama.AuditDate,
		ama.AuditID,
		ama.SiteID,
		ama.ReasonID,
		(SELECT Description FROM AutoModAuditReasons amar WHERE amar.ReasonID=4) Reason,
		ama.TrustPoints,
		ama.ModStatus,
		(SELECT count(*) FROM UserAudit) Total
FROM UserAudit ua
INNER JOIN dbo.automodaudit ama ON ua.auditdate=ama.auditdate AND ua.auditid=ama.auditid
WHERE n>@skip AND n<=(@skip+@show)
ORDER BY n