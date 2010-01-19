<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:dna="BBC.Dna.Api"
      exclude-result-prefixes="xs dna"
      version="2.0">
	
	<xsl:function name="dna:formatDateTime" as="xs:dateTime">
		<xsl:param name="date"/>
		<xsl:variable name="dateSequence" select="tokenize(substring-before($date, ' '), '/')"/>	
		<xsl:variable name="time" select="substring-after($date, ' ')"/>
		<xsl:value-of select="concat($dateSequence[3], '-', $dateSequence[2], '-', $dateSequence[1], 'T', $time)"/>
	</xsl:function>

</xsl:stylesheet>
