CREATE PROCEDURE removesiteevents
AS


set transaction isolation level read uncommitted;

delete from dbo.SiteActivityQueue
