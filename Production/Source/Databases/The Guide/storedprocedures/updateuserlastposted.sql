CREATE PROCEDURE updateuserlastposted @userid int, @siteid int
As

IF EXISTS(SELECT * FROM UserLastPosted WHERE UserID=@userid AND SiteID=@siteid)
BEGIN
	UPDATE UserLastPosted SET LastPosted = getdate() WHERE UserID=@userid AND SiteID=@siteid
END
ELSE
BEGIN
	INSERT INTO UserLastPosted (UserID,SiteID,LastPosted) VALUES(@userid,@siteid,getdate())
END
