PRINT 'Creating Database Tables...'

-- Remove constraints so we can drop tables
IF (OBJECTPROPERTY(OBJECT_ID('Hierarchy'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE Hierarchy DROP CONSTRAINT FK_h_parentid
END

IF (OBJECTPROPERTY(OBJECT_ID('HierarchyArticleMembers'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE HierarchyArticleMembers DROP CONSTRAINT FK_ham_h2g2id
	ALTER TABLE HierarchyArticleMembers DROP CONSTRAINT FK_ham_nodeid
END

IF (OBJECTPROPERTY(OBJECT_ID('Threads'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE Threads DROP CONSTRAINT FK_t_forumid
END

IF (OBJECTPROPERTY(OBJECT_ID('GuideEntries'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE GuideEntries DROP CONSTRAINT FK_ge_forumid
	ALTER TABLE GuideEntries DROP CONSTRAINT FK_ge_editor
END

IF (OBJECTPROPERTY(OBJECT_ID('ThreadEntries'),'IsUserTable') IS NOT NULL) 
BEGIN
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_forumid
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_userid
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_nextsibling
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_parent
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_prevsibling
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_firstchild
	ALTER TABLE ThreadEntries DROP CONSTRAINT FK_te_threadid
END

IF (OBJECTPROPERTY(OBJECT_ID('ThreadEditHistory'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE ThreadEditHistory DROP CONSTRAINT FK_teh_forumid
	ALTER TABLE ThreadEditHistory DROP CONSTRAINT FK_teh_threadid
END

IF (OBJECTPROPERTY(OBJECT_ID('Users'),'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE Users DROP CONSTRAINT FK_u_masthead
END

IF(OBJECTPROPERTY(OBJECT_ID('ReviewForums'), 'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE ReviewForums DROP CONSTRAINT FK_rf_h2g2id
END

IF(OBJECTPROPERTY(OBJECT_ID('KeyArticles'), 'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE KeyArticles DROP CONSTRAINT FK_ka_entryid
END

IF(OBJECTPROPERTY(OBJECT_ID('Friends'), 'IsUserTable') IS NOT NULL)
BEGIN
	ALTER TABLE Friends DROP CONSTRAINT FK_f_userid
	ALTER TABLE Friends DROP CONSTRAINT FK_f_friendid
END

-- Drop tables
IF (OBJECTPROPERTY(OBJECT_ID('Hierarchy'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE Hierarchy
END

IF (OBJECTPROPERTY(OBJECT_ID('HierarchyArticleMembers'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE HierarchyArticleMembers
END

IF (OBJECTPROPERTY(OBJECT_ID('Forums'),'IsUserTable') IS NOT NULL) 
BEGIN
	DROP TABLE Forums
END

IF (OBJECTPROPERTY(OBJECT_ID('Threads'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE Threads
END

IF (OBJECTPROPERTY(OBJECT_ID('GuideEntries'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE GuideEntries
END

IF (OBJECTPROPERTY(OBJECT_ID('ThreadEntries'),'IsUserTable') IS NOT NULL) 
BEGIN
	DROP TABLE ThreadEntries
END

IF (OBJECTPROPERTY(OBJECT_ID('ThreadEditHistory'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE ThreadEditHistory
END

IF (OBJECTPROPERTY(OBJECT_ID('Users'),'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE Users
END

IF(OBJECTPROPERTY(OBJECT_ID('ReviewForums'), 'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE ReviewForums
END

IF(OBJECTPROPERTY(OBJECT_ID('KeyArticles'), 'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE KeyArticles
END

IF(OBJECTPROPERTY(OBJECT_ID('Friends'), 'IsUserTable') IS NOT NULL)
BEGIN
	DROP TABLE Friends
END

-- Create Tables with primary keys
CREATE TABLE GuideEntries
(
	h2g2id int NOT NULL CONSTRAINT PK_h2g2id PRIMARY KEY,
	forumid int NOT NULL DEFAULT(0),
	editor int NOT NULL DEFAULT(0),
	datecreated datetime,
	lastupdated datetime,
	subject varchar(255),
	text text,
	extrainfo text,
	type int,
	style int,
	status int,
	hidden int
)

CREATE TABLE Forums
(
	forumid int NOT NULL CONSTRAINT PK_forumid PRIMARY KEY,
	title varchar(255),
	lastposted datetime,
	lastupdated datetime,
	datecreated datetime,
	forumpostcount int
)

CREATE TABLE Threads
(
	threadid int NOT NULL CONSTRAINT PK_threadid PRIMARY KEY,
	forumid int NOT NULL DEFAULT(0),
	datecreated datetime,
	lastposted datetime,
	lastupdated datetime,
	threadpostcount int,
	firstsubject varchar(255)
)

CREATE TABLE ThreadEntries
(
	entryid int NOT NULL CONSTRAINT PK_entryid PRIMARY KEY,
	forumid int NOT NULL DEFAULT(0),
	threadid int NOT NULL DEFAULT(0),
	userid int NOT NULL DEFAULT(0),
	nextsibling int,
	parent int,
	prevsibling int,
	firstchild int,	
	dateposted datetime,
	subject varchar(255),
	postindex int,
	text text,
	lastupdated datetime
)

CREATE TABLE ThreadEditHistory
(
	entryid int NOT NULL DEFAULT(0),
	forumid int NOT NULL DEFAULT(0),
	threadid int NOT NULL DEFAULT(0),	
	text text,
	oldsubject varchar(255),
	dateedited datetime
)

CREATE TABLE Users
(
	userid int NOT NULL CONSTRAINT PK_userid PRIMARY KEY,
	masthead int,
	journal int,
	username varchar(255)
)

CREATE TABLE Hierarchy
(
	nodeid int NOT NULL CONSTRAINT PK_nodeid PRIMARY KEY,
	parentid int,
	displayname varchar(255),
	treelevel int,
	nodemembers int,
	articlemembers int,
	nodealiasmembers int,
	description varchar(1023),
	synonyms varchar(4096),
	type int
)

CREATE TABLE HierarchyArticleMembers
(
	h2g2id int NOT NULL DEFAULT(0),
	nodeid int NOT NULL DEFAULT(0)
)

CREATE TABLE ReviewForums
(
	reviewforumid int NOT NULL CONSTRAINT PK_reviewforumid PRIMARY KEY,
	h2g2id int NOT NULL DEFAULT(0),
	forumname varchar(50),
	urlfriendlyname varchar(50)	
)

CREATE TABLE KeyArticles
(
	articlename varchar(128) NOT NULL,
	entryid int NOT NULL DEFAULT(0)
)

CREATE TABLE Friends
(
	userid int NOT NULL DEFAULT(0),
	friendid int NOT NULL DEFAULT(0)
)

-- Add foreign keys
ALTER TABLE GuideEntries ADD 
	CONSTRAINT FK_ge_forumid FOREIGN KEY(forumid) REFERENCES Forums(forumid),
	CONSTRAINT FK_ge_editor FOREIGN KEY(editor) REFERENCES Users(userid)

ALTER TABLE GuideEntries NOCHECK CONSTRAINT FK_ge_forumid
ALTER TABLE GuideEntries NOCHECK CONSTRAINT FK_ge_editor

ALTER TABLE Threads ADD 
	CONSTRAINT FK_t_forumid FOREIGN KEY(forumid) REFERENCES Forums(forumid)

ALTER TABLE Threads NOCHECK CONSTRAINT FK_t_forumid

ALTER TABLE ThreadEntries ADD 
	CONSTRAINT FK_te_forumid FOREIGN KEY(forumid) REFERENCES Forums(forumid),
	CONSTRAINT FK_te_userid FOREIGN KEY(userid) REFERENCES Users(userid),
	CONSTRAINT FK_te_nextsibling FOREIGN KEY(nextsibling) REFERENCES ThreadEntries(entryid),
	CONSTRAINT FK_te_parent FOREIGN KEY(parent) REFERENCES ThreadEntries(entryid),
	CONSTRAINT FK_te_prevsibling FOREIGN KEY(prevsibling) REFERENCES ThreadEntries(entryid),
	CONSTRAINT FK_te_firstchild FOREIGN KEY(firstchild) REFERENCES ThreadEntries(entryid),
	CONSTRAINT FK_te_threadid FOREIGN KEY(firstchild) REFERENCES Threads(threadid)

ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_forumid
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_userid
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_nextsibling
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_parent
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_prevsibling
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_firstchild
ALTER TABLE ThreadEntries NOCHECK CONSTRAINT FK_te_threadid

ALTER TABLE ThreadEditHistory ADD 
	CONSTRAINT FK_teh_forumid FOREIGN KEY(forumid) REFERENCES Forums(forumid),
	CONSTRAINT FK_teh_threadid FOREIGN KEY(threadid) REFERENCES Threads(threadid)

ALTER TABLE ThreadEditHistory NOCHECK CONSTRAINT FK_teh_forumid
ALTER TABLE ThreadEditHistory NOCHECK CONSTRAINT FK_teh_threadid

ALTER TABLE Users ADD 
	CONSTRAINT FK_u_masthead FOREIGN KEY(masthead) REFERENCES GuideEntries(h2g2id)

ALTER TABLE Users NOCHECK CONSTRAINT FK_u_masthead

ALTER TABLE Hierarchy ADD 
	CONSTRAINT FK_h_parentid FOREIGN KEY(parentid) REFERENCES Hierarchy(nodeid)

ALTER TABLE Hierarchy NOCHECK CONSTRAINT FK_h_parentid

ALTER TABLE HierarchyArticleMembers ADD 
	CONSTRAINT FK_ham_h2g2id FOREIGN KEY(h2g2id) REFERENCES GuideEntries(h2g2id),
	CONSTRAINT FK_ham_nodeid FOREIGN KEY(nodeid) REFERENCES Hierarchy(nodeid)

ALTER TABLE HierarchyArticleMembers NOCHECK CONSTRAINT FK_ham_h2g2id
ALTER TABLE HierarchyArticleMembers NOCHECK CONSTRAINT FK_ham_nodeid

ALTER TABLE ReviewForums ADD
	CONSTRAINT FK_rf_h2g2id FOREIGN KEY(h2g2id) REFERENCES GuideEntries(h2g2id)

ALTER TABLE ReviewForums NOCHECK CONSTRAINT FK_rf_h2g2id

ALTER TABLE KeyArticles ADD
	CONSTRAINT FK_ka_entryid FOREIGN KEY(entryid) REFERENCES GuideEntries(h2g2id)

ALTER TABLE KeyArticles NOCHECK CONSTRAINT FK_ka_entryid

ALTER TABLE Friends ADD
	CONSTRAINT FK_f_userid FOREIGN KEY(userid) REFERENCES Users(userid),
	CONSTRAINT FK_f_friendid FOREIGN KEY(friendid) REFERENCES Users(userid)

ALTER TABLE Friends NOCHECK CONSTRAINT FK_f_userid
ALTER TABLE Friends NOCHECK CONSTRAINT FK_f_friendid

PRINT 'DONE'
PRINT 'Importing Data... please be patient, this will take a while'
GO

-- Stories (no user pages, those come later) --
INSERT INTO GuideEntries
	SELECT h2g2id, forumid, editor, datecreated, lastupdated, subject, text, extrainfo, type, style, status, hidden
	FROM NewGuide.dbo.GuideEntries
	WHERE SiteID = (SELECT SiteID FROM NewGuide.dbo.Sites WHERE URLName='WW2')
	AND (type < 3001 or type > 4000)

-- Categories --
INSERT INTO Hierarchy
	SELECT 	nodeid, parentid, displayname, treelevel, nodemembers, articlemembers, nodealiasmembers, description, synonyms, type
	FROM NewGuide.dbo.Hierarchy
	WHERE SiteID = (SELECT SiteID FROM NewGuide.dbo.Sites WHERE URLName='WW2')

INSERT INTO HierarchyArticleMembers
	SELECT ham.h2g2id, ham.nodeid
	FROM NewGuide.dbo.HierarchyArticleMembers ham
	INNER JOIN NewGuide.dbo.Hierarchy h ON h.nodeid = ham.nodeid
	WHERE h.SiteID = (SELECT SiteID FROM NewGuide.dbo.Sites WHERE URLName='WW2')

-- Story Forums+Personal spaces forums + their Threads and ThreadEditHistory --
INSERT INTO Forums
	SELECT f.forumid, f.title, f.lastposted, f.lastupdated, f.datecreated, f.forumpostcount
	FROM NewGuide.dbo.Forums f
	INNER JOIN GuideEntries g on g.forumid = f.forumid

-- Threads and ThreadEntries (including auto generated ones)
INSERT INTO Threads
	SELECT t.threadid, t.forumid, t.datecreated, t.lastposted, t.lastupdated, t.threadpostcount, t.firstsubject
	FROM NewGuide.dbo.Threads t
	INNER JOIN Forums f ON f.forumid = t.forumid

INSERT INTO ThreadEntries
	SELECT te.entryid, te.forumid, te.threadid, te.userid, te.nextsibling, te.parent, te.prevsibling, te.firstchild, te.dateposted, te.subject, te.postindex, te.text, te.lastupdated
	FROM NewGuide.dbo.ThreadEntries te
	INNER JOIN Threads t ON t.ThreadID = te.ThreadID

INSERT INTO ThreadEditHistory
	SELECT teh.entryid, teh.forumid, teh.threadid, teh.text, teh.oldsubject, teh.dateedited
	FROM NewGuide.dbo.ThreadEditHistory teh
	INNER JOIN Threads t ON t.threadid = teh.threadid

-- WW2 Users: Authors of threads and stories --
INSERT INTO Users
	SELECT userid, masthead, journal, username
	FROM NewGuide.dbo.Users u
	WHERE u.UserID in (select editor from GuideEntries UNION select userid from ThreadEntries)

-- Personal pages
INSERT INTO GuideEntries
	SELECT h2g2id, forumid, editor, datecreated, lastupdated, subject, text, extrainfo, type, style, status, hidden
	FROM NewGuide.dbo.GuideEntries ge
	WHERE h2g2id in (SELECT masthead from Users)
	AND (ge.type > 3000 AND ge.type < 4001)
	
-- Review Forums metadata
INSERT INTO ReviewForums
	SELECT reviewforumid, h2g2id, forumname, urlfriendlyname
	FROM NewGuide.dbo.ReviewForums rf
	WHERE rf.siteid = (SELECT SiteID FROM NewGuide.dbo.Sites WHERE URLName='WW2')

-- Key Articles
INSERT INTO KeyArticles
	SELECT articlename, entryid
	FROM NewGuide.dbo.KeyArticles ka
	WHERE ka.SiteID = (SELECT SiteID FROM NewGuide.dbo.Sites WHERE URLName='WW2')

-- Friends
INSERT INTO Friends
	SELECT u.userid, friends.userid
	FROM Users u
	INNER JOIN NewGuide.dbo.FaveForums ff on ff.forumid = u.journal
	INNER JOIN NewGuide.dbo.Users friends on friends.userid = ff.userid
	INNER JOIN NewGuide.dbo.Forums fo ON fo.ForumID = friends.Journal

PRINT 'DONE'