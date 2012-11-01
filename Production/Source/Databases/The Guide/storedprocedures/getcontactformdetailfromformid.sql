CREATE PROCEDURE getcontactformdetailfromformid @contactformid nvarchar(255), @sitename varchar(255)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
EXEC openemailaddresskey;
SELECT
	'ForumID' = vcf.ForumID,
	'ParentURI' = vcf.URL,
	'Title' = vcf.Title,
	'ContactEmail' = ISNULL(dbo.udf_decryptemailaddress(cf.EncryptedContactEmail,cf.ForumID), s.ContactFormsEmail),
	'ContactFormUID' = vcf.UID,
	'NotSignedInUserId' = vcf.NotSignedInUserId
FROM dbo.VCommentForums vcf
INNER JOIN dbo.ContactForms cf ON vcf.ForumID = cf.ForumID
INNER JOIN dbo.Sites s ON s.SiteID = vcf.SiteID
WHERE vcf.UID = @contactformid