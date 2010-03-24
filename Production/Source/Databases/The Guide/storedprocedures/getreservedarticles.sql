Create Procedure getreservedarticles @userid int
As

SELECT * FROM guideentries WHERE subject='reserved' AND editor=@userid
