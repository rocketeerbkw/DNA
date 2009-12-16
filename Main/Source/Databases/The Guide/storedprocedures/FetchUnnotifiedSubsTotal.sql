create procedure fetchunnotifiedsubstotal
as
select count(*) as Total
from Users U
inner join AcceptedRecommendations AR on AR.SubEditorID = U.UserID
where AR.NotificationSent = 0
return (0)
