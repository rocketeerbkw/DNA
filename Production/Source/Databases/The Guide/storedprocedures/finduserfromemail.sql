Create Procedure finduserfromemail @email varchar(255)
As

EXEC openemailaddresskey;

SELECT	UserID
      ,Cookie
      ,dbo.udf_decryptemailaddress(u.EncryptedEmail,u.userid) AS Email
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
FROM Users u 
WHERE dbo.udf_decryptemailaddress(u.EncryptedEmail,u.userid) = @email AND Status <> 0
UNION ALL
SELECT	UserID
      ,Cookie
      ,dbo.udf_decryptemailaddress(u.EncryptedEmail,u.userid) AS Email
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
FROM Users u 
WHERE LoginName = @email AND Status <> 0

order by UserID
	return (0)
	