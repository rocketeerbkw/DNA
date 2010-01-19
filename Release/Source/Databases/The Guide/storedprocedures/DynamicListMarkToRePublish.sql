-- Marks active lists to be re-published.
--
create procedure dynamiclistmarktorepublish
as

--Republish dynamic lists by marking active lists as awaiting publish.
--This occurs where existing lists are void due to a DB Schema change.
update dynamiclistdefinitions set PublishState = 1
where PublishState = 2
return  @@ERROR
