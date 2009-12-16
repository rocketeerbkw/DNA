<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:dna="BBC.Dna.Api"
      xmlns:doc="http://www.bbc.co.uk/dna/documentation"
      exclude-result-prefixes="xs dna doc"
      version="2.0">
	
	<doc:documentation>
		<doc:purpose>
			Re-format a DNA date into xs:dateTime
		</doc:purpose>
		<doc:context>
			None. This is a standalone XSLT function.
		</doc:context>
		<doc:notes>
			param $date The date to be formatted, in DNA's format (DD/MM/YYYY hh:mm:ss)
			returns An xs:dateTime
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:function name="dna:formatDateTime" as="xs:dateTime">
		<xsl:param name="date"/>
		<xsl:variable name="dateSequence" select="tokenize(substring-before($date, ' '), '/')"/>	
		<xsl:variable name="time" select="substring-after($date, ' ')"/>
		<xsl:value-of select="concat($dateSequence[3], '-', $dateSequence[2], '-', $dateSequence[1], 'T', $time)"/>
	</xsl:function>

</xsl:stylesheet>
