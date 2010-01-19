CREATE PROCEDURE getarticlemoddetailsfrommodid @modid int
AS

SELECT * from ArticleMod tm where tm.modid = @modid
return (0)