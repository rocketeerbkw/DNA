CREATE PROCEDURE insertsiteactivityitem
	@type int
    ,@activitydata xml
    ,@datetime datetime
    ,@siteid int
AS
BEGIN

insert into SiteActivityItems
(type, activitydata, datetime, siteid)
values
(@type, @activitydata, @datetime, @siteid)

	
END