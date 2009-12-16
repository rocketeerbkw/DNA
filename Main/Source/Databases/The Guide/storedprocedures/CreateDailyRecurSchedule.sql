CREATE PROCEDURE createdailyrecurschedule @siteid INT, @recurrenteventopenhours INT, @recurrenteventclosehours INT, @recurrenteventopenminutes INT, @recurrenteventcloseminutes INT
AS
DECLARE @Error int
BEGIN TRANSACTION

DELETE FROM dbo.SiteTopicsOpenCloseTimes WHERE SiteID = @siteID
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 1, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 1, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 2, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 2, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 3, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 3, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 4, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 4, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 5, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 5, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 6, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 6, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 7, @recurrenteventopenhours, @recurrenteventopenminutes, 0)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

INSERT INTO dbo.SiteTopicsOpenCloseTimes (SiteID, DayWeek, Hour, Minute, Closed) VALUES (@siteid, 7, @recurrenteventclosehours, @recurrenteventcloseminutes, 1)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

COMMIT TRANSACTION
RETURN 0

-- Handle the error
HandleError:
BEGIN
	ROLLBACK TRANSACTION
	EXEC error @Error
	RETURN @Error
END

