CREATE PROCEDURE getcontactformdetailfromformid @contactformid nvarchar(255), @sitename varchar(255)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
	'ForumID' = vcf.ForumID,
	'ParentURI' = vcf.URL,
	'Title' = vcf.Title,
	'ContactEmail' = cf.EncryptedContactEmail,
	'ContactFormUID' = vcf.UID
FROM dbo.VCommentForums vcf
INNER JOIN dbo.ContactForms cf ON vcf.ForumID = cf.ForumID
INNER JOIN dbo.Sites s ON s.SiteID = vcf.SiteID
WHERE vcf.UID = @contactformid