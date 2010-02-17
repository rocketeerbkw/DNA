delete from SiteTopicsOpenCloseTimes

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 
	   CASE 
		WHEN fse.DayType = 0 THEN 2
		WHEN fse.DayType = 1 THEN 3
		WHEN fse.DayType = 2 THEN 4
		WHEN fse.DayType = 3 THEN 5
		WHEN fse.DayType = 4 THEN 6
		WHEN fse.DayType = 5 THEN 7
		WHEN fse.DayType = 6 THEN 1
	   END as daytime, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType <> 7
   and t.TopicStatus = 0 

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 1, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 2, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 3, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 4, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 5, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 6, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

insert into SiteTopicsOpenCloseTimes
select distinct s.SiteID, 7, 
	   datepart(hh, fse.NextRun) as hours, 
	   datepart(mi, fse.NextRun) as minutes, 
	   CASE 
		WHEN fse.Action = 0 THEN 1 
		ELSE 0 
	   END as action 
  from ForumScheduledEvents fse
	   inner join Forums f on f.ForumID = fse.ForumID
	   inner join GuideEntries ge on ge.ForumID = fse.ForumID
	   inner join Topics t on t.h2g2ID = ge.h2g2ID
	   inner join Sites s on f.SiteID = s.SiteID
 where fse.EventType = 1
   and fse.DayType = 7
   and t.TopicStatus = 0 
   and fse.ForumID not in (select fse2.ForumID 
						 from ForumScheduledEvents fse2
						group by fse2.ForumID
						having count(*) = 1)

DECLARE @SiteID		INT

DECLARE EventTidyUp CURSOR 
    FOR select SiteID
		  from SiteTopicsOpenCloseTimes
		 group by SiteID
		having count(*) != 14

OPEN EventTidyUp

FETCH NEXT FROM EventTidyUp INTO @SiteID

WHILE @@FETCH_STATUS = 0
BEGIN
	-- delete dupicate open times	
	delete
	  from SiteTopicsOpenCloseTimes
	 where Hour > (select MIN(Hour)
					 from SiteTopicsOpenCloseTimes fst
					where fst.SiteID = SiteTopicsOpenCloseTimes.SiteID
					  and fst.DayWeek = SiteTopicsOpenCloseTimes.DayWeek
					  and fst.Closed = SiteTopicsOpenCloseTimes.Closed)
	   and SiteTopicsOpenCloseTimes.SiteID = @SiteID
	   and SiteTopicsOpenCloseTimes.Closed = 0 
	
	-- delete dupicate close times
	delete
	  from SiteTopicsOpenCloseTimes
	 where Hour < (select MAX(fst.Hour)
					 from SiteTopicsOpenCloseTimes fst
					where fst.SiteID = SiteTopicsOpenCloseTimes.SiteID
					  and fst.DayWeek = SiteTopicsOpenCloseTimes.DayWeek
					  and fst.Closed = SiteTopicsOpenCloseTimes.Closed)
	   and SiteTopicsOpenCloseTimes.SiteID = @SiteID
	   and SiteTopicsOpenCloseTimes.Closed = 1

	FETCH NEXT FROM EventTidyUp INTO @SiteID
END

CLOSE EventTidyUp
DEALLOCATE EventTidyUp
