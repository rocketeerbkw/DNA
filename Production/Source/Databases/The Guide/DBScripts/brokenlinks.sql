--This script looks for urls missing the http:// part.
--It is assumed all links are external which is the case as of 7/12/2005 - ( A check can be made first by commenting out the update . )
--declare @temp table(txt VARCHAR(8000), h2g2id int )
--INSERT INTO @temp
--select REPLACE(CAST(ExtraInfo AS VARCHAR(8000)),'<LINKURL>','<LINKURL>http://' ) 'txt', h2g2id
--from GuideEntries 
--where siteid = 16 AND type=6 and PATINDEX('%<LINKURL>[^h][^t][^t][^p][^:][^/][^/]%',ExtraInfo) > 0

--Update GuideEntries 
--set GuideEntries.extrainfo = ( select txt 'extrainfo' from @temp t
-- 				where GuideEntries.h2g2id = t.h2g2id )

--select SUBSTRING(extrainfo,PATINDEX('%<LINKURL>%',extrainfo),PATINDEX('%</LINKURL>%',extrainfo) - PATINDEX('%<LINKURL>%',extrainfo)) 'urls', t.h2g2id 
--from GuideEntries g
--INNER JOIN @temp t ON t.h2g2Id = g.h2g2id 

Create Procedure brokenlinks @h2g2id int 
AS 
BEGIN

	--get extra info link url 
	declare @fixedurl varchar(8000)
	select @fixedurl = REPLACE(CAST(ExtraInfo AS VARCHAR(8000)),'<LINKURL>','<LINKURL>http://' )
	from GuideEntries 
	where h2g2id = @h2g2id AND siteid = 16 AND type=6 and PATINDEX('%<LINKURL>[^h][^t][^t][^p][^:][^/][^/]%',ExtraInfo) > 0
	
	IF @fixedurl IS NOT NULL
	BEGIN
		Update GuideEntries 
		set GuideEntries.extrainfo = @fixedurl where h2g2id = @h2g2id
	END

END

GO

--Call fix up url for the relevant items
--Rather than use a cursor or dynamic update the results of the query above are used as single updates ( for performance ).
exec brokenlinks 	4448234
exec brokenlinks 	5132459
exec brokenlinks 	4462256
exec brokenlinks 	4463444
exec brokenlinks 	4463480
exec brokenlinks 	4990638
exec brokenlinks 	5194460
exec brokenlinks 	5195270
exec brokenlinks 	4489202
exec brokenlinks 	5011057
exec brokenlinks 	5013938
exec brokenlinks 	5013802
exec brokenlinks 	5013703
exec brokenlinks 	4482768
exec brokenlinks 	4480364
exec brokenlinks 	4481165
exec brokenlinks 	4481426
exec brokenlinks 	4481688
exec brokenlinks 	4481750
exec brokenlinks 	4480580
exec brokenlinks 	4481589
exec brokenlinks 	4495368
exec brokenlinks 	5067894
exec brokenlinks 	5374938
exec brokenlinks 	5374992
exec brokenlinks 	4500640
exec brokenlinks 	5087856
exec brokenlinks 	5068127
exec brokenlinks 	4536597
exec brokenlinks 	4321900
exec brokenlinks 	5245698
exec brokenlinks 	4322053
exec brokenlinks 	4562020
exec brokenlinks 	4622852
exec brokenlinks 	4630628
exec brokenlinks 	4630664
exec brokenlinks 	4630691
exec brokenlinks 	4630637
exec brokenlinks 	4358522
exec brokenlinks 	4360105
exec brokenlinks 	4364804
exec brokenlinks 	4364912
exec brokenlinks 	4620980
exec brokenlinks 	4632149
exec brokenlinks 	4389951
exec brokenlinks 	5628512
exec brokenlinks 	4396953
exec brokenlinks 	4401712
exec brokenlinks 	4679698
exec brokenlinks 	4651661
exec brokenlinks 	5869740
exec brokenlinks 	5869768
exec brokenlinks 	5813499
exec brokenlinks 	4827675
exec brokenlinks 	5804246
exec brokenlinks 	5758095
exec brokenlinks 	5906135
exec brokenlinks 	6609242
exec brokenlinks 	6366477
exec brokenlinks 	6484034
exec brokenlinks 	6775770
exec brokenlinks 	6464577
exec brokenlinks 	6055733
exec brokenlinks 	6056282
exec brokenlinks 	6589461
exec brokenlinks 	6589696
exec brokenlinks 	6589308
exec brokenlinks 	6088520
exec brokenlinks 	6117374
exec brokenlinks 	6134096
exec brokenlinks 	6074967
exec brokenlinks 	6075001
exec brokenlinks 	6306860
exec brokenlinks 	4963782

drop procedure brokenlinks

GO



