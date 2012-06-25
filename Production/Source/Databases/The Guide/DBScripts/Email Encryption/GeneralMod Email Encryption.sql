-- Create the new column
ALTER TABLE dbo.GeneralMod  ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
GO

-- Create a trigger that will ensure the encrypted field is kept up to date
-- This will start populating the column with new threadmod rows straight away
CREATE TRIGGER trg_GeneralMod_iu ON GeneralMod 
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc

	IF UPDATE(CorrespondenceEmail)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE gm
			SET EncryptedCorrespondenceEmail = dbo.udf_encryptemailaddress(gm.CorrespondenceEmail,gm.ModId)
			FROM GeneralMod  gm
			INNER JOIN inserted i ON i.ModId=gm.ModId
	END
GO

-- Get a list of all the rows that need updating
if object_id('tempdb..#gm') is not null
	drop table #gm
select modid into #gm
	from GeneralMod
	where CorrespondenceEmail is not null
create unique clustered index CIX_gm on #gm(modid)

-- Important: Open the encryption key!
exec openemailaddresskey

-- Update all rows in batches
declare @n int
set @n=1
while @n > 0
begin
	;with rows as
	(
		select top 1000 modid from #gm order by modid
	)
	update gm
		set EncryptedCorrespondenceEmail=dbo.udf_encryptemailaddress(CorrespondenceEmail,gm.ModId)
		from GeneralMod  gm
		join rows r on r.modid=gm.modid

	;with rows as
	(
		select top 1000 modid from #gm order by modid
	)
	delete rows
	set @n=@@rowcount
end
GO

