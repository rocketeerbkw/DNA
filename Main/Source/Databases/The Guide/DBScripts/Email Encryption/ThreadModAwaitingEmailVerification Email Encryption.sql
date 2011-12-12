-- Create the new column
ALTER TABLE dbo.ThreadModAwaitingEmailVerification ADD EncryptedCorrespondenceEmail varbinary(8000) NULL
GO

-- Create a trigger that will ensure the encrypted field is kept up to date
-- This will start populating the column with new threadmod rows straight away
CREATE TRIGGER trg_ThreadModAwaitingEmailVerification_iu ON ThreadModAwaitingEmailVerification
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc

	IF UPDATE(CorrespondenceEmail)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE tmaev
			SET EncryptedCorrespondenceEmail = dbo.udf_encryptemailaddress(tmaev.CorrespondenceEmail,tmaev.postid)
			FROM ThreadModAwaitingEmailVerification tmaev
			INNER JOIN inserted i ON i.ID=tmaev.ID
	END
GO

-- Get a list of all the rows that need updating
if object_id('tempdb..#tmaev') is not null
	drop table #tmaev
select id into #tmaev
	from ThreadModAwaitingEmailVerification
	where CorrespondenceEmail is not null
create unique clustered index CIX_tmaev on #tmaev(id)

-- Important: Open the encryption key!
exec openemailaddresskey

-- Update all rows in batches
declare @n int
set @n=1
while @n > 0
begin
	;with rows as
	(
		select top 1000 id from #tmaev order by id
	)
	update tmaev
		set EncryptedCorrespondenceEmail=dbo.udf_encryptemailaddress(CorrespondenceEmail,tmaev.postid)
		from ThreadModAwaitingEmailVerification tmaev
		join rows r on r.id=tmaev.id

	;with rows as
	(
		select top 1000 id from #tmaev order by id
	)
	delete rows
	set @n=@@rowcount
end
GO

