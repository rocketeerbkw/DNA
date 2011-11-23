-- Create the new column
ALTER TABLE dbo.ThreadMod ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
GO

-- Create a trigger that will ensure the encrypted field is kept up to date
-- This will start populating the column with new threadmod rows straight away
CREATE TRIGGER trg_ThreadMod_iu ON ThreadMod
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc

	IF UPDATE(CorrespondenceEmail)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE tm
			SET EncryptedCorrespondenceEmail = dbo.udf_encryptemailaddress(tm.CorrespondenceEmail,tm.ModId)
			FROM ThreadMod tm
			INNER JOIN inserted i ON i.ModId=tm.ModId
	END
GO

-- Get a list of all the rows that need updating
if object_id('tempdb..#tm') is not null
	drop table #tm
select modid into #tm
	from ThreadMod
	where CorrespondenceEmail is not null
create unique clustered index CIX_tm on #tm(modid)

-- Important: Open the encryption key!
exec openemailaddresskey

-- Update all rows in batches
declare @n int
set @n=1
while @n > 0
begin
	;with rows as
	(
		select top 1000 modid from #tm order by modid
	)
	update tm
		set EncryptedCorrespondenceEmail=dbo.udf_encryptemailaddress(CorrespondenceEmail,tm.modid)
		from threadmod tm
		join rows r on r.modid=tm.modid

	;with rows as
	(
		select top 1000 modid from #tm order by modid
	)
	delete rows
	set @n=@@rowcount
end
GO

