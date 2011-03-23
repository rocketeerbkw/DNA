/*
 18/3/2011

 This script updates the bbc divisions that sites belong to based on a spread sheet from 
 Paul Wakely, emailed on 17th March
*/

if dbo.udf_indexexists('BBCDivision','IX_BBCDivisionName') = 0
  create unique index IX_BBCDivisionName on BBCDivision(BBCDivisionName)

update bbcdivision set BBCDivisionName='Knowledge and Learning' where BBCDivisionName like '%Knowledge%'

if not exists(select * from bbcdivision where BBCDivisionName='Knowledge and Learning')
	insert bbcdivision (BBCDivisionName) values('Knowledge and Learning')

if not exists(select * from bbcdivision where BBCDivisionName='News')
	insert bbcdivision (BBCDivisionName) values('News')

if not exists(select * from bbcdivision where BBCDivisionName='Sport')
	insert bbcdivision (BBCDivisionName) values('Sport')

if not exists(select * from bbcdivision where BBCDivisionName='TV/iPlayer')
	insert bbcdivision (BBCDivisionName) values('TV/iPlayer')

declare @fmt int,@AandM int, @knowledge int, @news int, @sport int, @tviplayer int, @undefined int, @worldservice int

select @AandM=BBCDivisionID from BBCDivision where BBCDivisionName='Audio and Music'
select @fmt=BBCDivisionID from BBCDivision where BBCDivisionName='FM&T'
select @knowledge=BBCDivisionID from BBCDivision where BBCDivisionName='Knowledge and Learning'
select @news=BBCDivisionID from BBCDivision where BBCDivisionName='News'
select @sport=BBCDivisionID from BBCDivision where BBCDivisionName='Sport'
select @tviplayer=BBCDivisionID from BBCDivision where BBCDivisionName='TV/iPlayer'
select @undefined=BBCDivisionID from BBCDivision where BBCDivisionName='Undefined'
select @worldservice=BBCDivisionID from BBCDivision where BBCDivisionName='World Service'

--select @fmt,@AandM , @knowledge , @news , @sport , @tviplayer , @undefined , @worldservice

update sites set BBCDivisionID=@AandM where urlname in ('iplayerradio','blog449')

update sites set BBCDivisionID=@fmt where urlname in ('blog286','flowsocialcore')

update sites set BBCDivisionID=@knowledge where urlname in 
('blog566','blog237','mbreligion','mbgcsebitesize','mbgardening','mbks3bitesize','mbhistory','mbouch',
'mbparents','mbfood','blog534','blog550','slink','blog121','mbstudentlife','blog290','blog74','blog16',
'blog558','mbblast','filmnetwork-identity','switch','blog585')

update sites set BBCDivisionID=@news where urlname in 
('blog477','blog69','blog392','blog9','blog242','blog394','blog81','blog142','blog198','blog307','blog14',
'blog82','blog98','blog547','blog140','blog456','blog139','blog420','blog23','blog172','blog80','blog136',
'blog519','blog146','blog358','blog299','blog457','blog141','blog567','blog215','blog185','blog375','blog524',
'blog491','blog462','blog55','blog397','blog508','blog60','blog574','blog473','blog377','scotlandsmusic','blog325',
'blog130','blog504','blog407','blog285','blog499','blog327','blog298','blog197','blog399','blog126','blog509',
'blog496','blog326','blog516','blog402','blog471','blog538','blog365','blog506','blog518','blog173','blog445',
'blog366','blog470','blog252','blog199','blog344','blog515','blog222','blog103','blog8','newscommentsmodule',
'blog28')

update sites set BBCDivisionID=@sport where urlname in 
('606','blog376','blog382','blog289','blog448','blog355','blog398','blog510','blog152','blog393',
'blog207','blog160','blog254','blog206','blog239','blog453','blog264','blog162','blog256','blog565',
'blog521','blog348','blog208','blog248','blog155','blog347','blog345','blog532','blog209',
'blog362','blog210','blog484','blog454','blog346','blog539','blog266','blog118','blog115',
'blog485','blog226','blog163','blog587')

update sites set BBCDivisionID=@tviplayer where urlname in 
('iplayertv','blog578','blog583','blog221','mbpointsofview','blog443','blog474','blog469','blog243',
'blog404','comedyextraidentity','dragonsden','blog182','blog168','blog563','blog434','blog191','buzzindex')

update sites set BBCDivisionID=@worldservice where urlname in 
('blog189','blog493','blog582','blog576')

