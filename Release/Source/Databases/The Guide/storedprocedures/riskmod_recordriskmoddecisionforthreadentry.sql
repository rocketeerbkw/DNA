CREATE PROCEDURE riskmod_recordriskmoddecisionforthreadentry @siteid int, @forumid int, @threadentryid int, @risky bit
AS

INSERT dbo.RiskModDecisionsForThreadEntries (SiteId, ForumId, ThreadEntryId, IsRisky)
	VALUES(@siteid, @forumid, @threadentryid, @risky)