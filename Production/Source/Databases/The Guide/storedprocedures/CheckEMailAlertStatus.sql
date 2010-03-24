CREATE PROCEDURE checkemailalertstatus @iinstanttimerange int, @inormaltimerange int
AS
DECLARE @InstantEMail int, @NormalEMail int
EXEC SetItemListTypeValInternal 'LT_INSTANTEMAILALERT', @InstantEMail output
EXEC SetItemListTypeValInternal 'LT_EMAILALERT', @NormalEMail output
DECLARE @OverDueEmails int
SELECT @OverDueEMails = COUNT(*) FROM EMailEventQueue eeq WITH(NOLOCK)
LEFT JOIN dbo.EMailAlertList il WITH(NOLOCK) ON il.EmailAlertListID = eeq.ListID AND DATEDIFF(minute, eeq.EventDate, getdate()) > @iinstanttimerange
LEFT JOIN dbo.InstantEMailAlertList il2 WITH(NOLOCK) ON il2.InstantEmailAlertListID = eeq.ListID AND DATEDIFF(day, eeq.EventDate, getdate()) > @inormaltimerange
SELECT 'OverDueEMails' = @OverDueEMails
