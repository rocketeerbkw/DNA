-- Create the new column
ALTER TABLE dbo.ArticleMod ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
GO

-- Create a trigger that will ensure the encrypted field is kept up to date
-- This will start populating the column with new threadmod rows straight away
CREATE TRIGGER trg_ArticleMod_iu ON ArticleMod
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc

	IF UPDATE(CorrespondenceEmail)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE am
			SET EncryptedCorrespondenceEmail = dbo.udf_encryptemailaddress(am.CorrespondenceEmail,am.ModId)
			FROM ArticleMod am
			INNER JOIN inserted i ON i.ModId=am.ModId
	END
GO

-- Get a list of all the rows that need updating
if object_id('tempdb..#am') is not null
	drop table #am
select modid into #am
	from ArticleMod
	where CorrespondenceEmail is not null
create unique clustered index CIX_am on #am(modid)

-- Important: Open the encryption key!
exec openemailaddresskey

-- Update all rows in batches
declare @n int
set @n=1
while @n > 0
begin
	;with rows as
	(
		select top 1000 modid from #am order by modid
	)
	update am
		set EncryptedCorrespondenceEmail=dbo.udf_encryptemailaddress(CorrespondenceEmail,am.ModId)
		from ArticleMod am
		join rows r on r.modid=am.modid

	;with rows as
	(
		select top 1000 modid from #am order by modid
	)
	delete rows
	set @n=@@rowcount
end
GO

