CREATE PROCEDURE processsitetopicsscheduledevent @siteid INT, @event VARCHAR(32)
AS
/* 
	Parses parameter event and inserts event into SiteTopicsOpenCloseTimes. 
	Event comes in the form dw_hh_mm_A where dw is the day of the week (1=Sunday, 7=Sat), 
	hh is the hour of the event (0-23 inclusive), mm is the minute of the event (0-55 inclusive) 
	and A is the action to be performed (0=open, 1=closed). 
*/
DECLARE @Error						INT
DECLARE @FirstUnderscoreCharIndex	INT
DECLARE @SecondUnderscoreCharIndex	INT
DECLARE @ThirdUnderscoreCharIndex	INT
DECLARE @EventDayWeek				INT
DECLARE @EventHour					INT
DECLARE @EventMinutes				INT
DECLARE @EventAction				INT

SELECT @FirstUnderscoreCharIndex = CHARINDEX('_', @event)
SELECT @SecondUnderscoreCharIndex = CHARINDEX('_', @event, @FirstUnderscoreCharIndex+1)
SELECT @ThirdUnderscoreCharIndex = CHARINDEX('_', @event, @SecondUnderscoreCharIndex+1)

SELECT @EventDayWeek = SUBSTRING(@event, 1, (@FirstUnderscoreCharIndex-1))
SELECT @EventHour = CAST(SUBSTRING(@event, (@FirstUnderscoreCharIndex + 1), (@SecondUnderscoreCharIndex - (@FirstUnderscoreCharIndex+1))) AS INT)
SELECT @EventMinutes = CAST(SUBSTRING(@event, (@SecondUnderscoreCharIndex + 1), (@ThirdUnderscoreCharIndex - (@SecondUnderscoreCharIndex+1))) AS INT)
SELECT @EventAction = CAST(SUBSTRING(@event, (@ThirdUnderscoreCharIndex + 1), (LEN(@event) - (@ThirdUnderscoreCharIndex))) AS INT)

BEGIN TRANSACTION

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) 
	VALUES (@siteid, @EventDayWeek, @EventHour, @EventMinutes, @EventAction)
SET @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

COMMIT TRANSACTION
