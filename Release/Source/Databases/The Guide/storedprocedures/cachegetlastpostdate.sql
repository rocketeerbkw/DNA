CREATE PROCEDURE cachegetlastpostdate @identityuserid varchar(40)
AS

declare @DnaUserID int
select @DnaUserID = DnaUserID from SignInUserIDMapping where IdentityUserID = @identityuserid

if (@DnaUserID IS NULL) 
BEGIN
	return 1 -- User not found
END

select top 1 LastPosted  from userlastposted where userid=@DnaUserID order by lastposted desc