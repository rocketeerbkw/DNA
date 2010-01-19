create procedure gettaxonomynodefromid @gisid varchar(100)
as
SELECT NodeID FROM NodeLink WHERE GISID = @gisid