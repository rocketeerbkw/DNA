CREATE  PROCEDURE finduserfromidandlogsession @userid int = NULL, @siteid int = 1
AS
-- just select every field since we want them all anyway
exec logusersession @userid, NULL, @siteid
exec finduserfromid @userid, NULL, @siteid

