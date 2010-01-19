CREATE PROCEDURE getmultiplehierarchynodedetails
			@node1 int = 0,@node2 int = 0,@node3 int = 0,@node4 int = 0,@node5  int = 0,
			@node6 int = 0,@node7 int = 0,@node8 int = 0,@node9 int = 0,@node10 int = 0
AS

SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node1
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node2
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node3
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node4
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node5
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node6
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node7
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node8
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node9
UNION
SELECT nodeid,type,siteid,displayname FROM hierarchy WHERE nodeid = @node10
ORDER BY type,nodeid
