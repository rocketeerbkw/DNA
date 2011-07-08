CREATE PROCEDURE getmatchinguseraccounts @firstnames varchar(255), @lastname varchar(255), @email varchar(255)
AS
BEGIN

EXEC openemailaddresskey;

SELECT UserID
       ,Cookie
       ,dbo.udf_decryptemailaddress(EncryptedEmail,UserId) AS Email
       ,UserName
       ,Password
       ,FirstNames
       ,LastName
       ,Active
       ,Masthead
       ,DateJoined
       ,Status
       ,Anonymous
       ,Journal
       ,Latitude
       ,Longitude
       ,SinBin
       ,DateReleased
       ,Prefs1
       ,Recommended
       ,Friends
       ,LoginName
       ,BBCUID
       ,TeamID
       ,Postcode
       ,Area
       ,TaxonomyNode
       ,UnreadPublicMessageCount
       ,UnreadPrivateMessageCount
       ,Region
       ,HideLocation
       ,HideUserName
       ,AcceptSubscriptions
       ,LastUpdatedDate
	FROM Users WHERE (FirstNames = @firstnames AND LastName = @lastname) OR (dbo.udf_hashemailaddress(@email)=hashedemail)
END
