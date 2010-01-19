-- Gets all global dynamic lists
-- Jamesp 19 jul 05
create procedure dynamiclistsgetglobal
as
select dynamiclistid, name, siteid, type from dynamiclists where global = 1