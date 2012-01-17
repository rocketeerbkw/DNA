ALTER TRIGGER trg_ArticleMod_iu ON ArticleMod
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
			AND i.CorrespondenceEmail IS NOT NULL
	END
GO

ALTER TRIGGER trg_GeneralMod_iu ON GeneralMod 
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
			AND i.CorrespondenceEmail IS NOT NULL
	END
GO

ALTER TRIGGER trg_ThreadMod_iu ON ThreadMod
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
			AND i.CorrespondenceEmail IS NOT NULL
	END
GO

ALTER TRIGGER trg_ThreadModAwaitingEmailVerification_iu ON ThreadModAwaitingEmailVerification
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
			AND i.CorrespondenceEmail IS NOT NULL
	END
GO
