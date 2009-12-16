CREATE FUNCTION udf_getkeyphrasenamespacepairs (@namespaces VARCHAR(MAX), @keyphrases VARCHAR(MAX))
RETURNS TABLE
AS
	/*
		Returns a table of keyphrase - namespace pairs. Keyphrases are matched with namespace from the two string by position. 
		Null is returned inplace of blank namespaces.
		No keyphrase or namespace may be blank. 
		null string can be passed in to represent no a null namespace - it will be converted to a db null in this function. 
	*/

	RETURN 
	SELECT	CASE WHEN ns.element = '_null' THEN NULL ELSE ns.element END as 'Namespace', 
			kp.element as 'Phrase'
	  FROM	udf_splitvarchar(@keyphrases) kp
			LEFT JOIN udf_splitvarchar(@namespaces) ns ON kp.pos = ns.pos
