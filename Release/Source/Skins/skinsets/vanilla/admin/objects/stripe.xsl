<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>

	<xsl:template name="objects_stripe">
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 1">odd</xsl:when>
				<xsl:otherwise>even</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute> 	
	</xsl:template>
	
</xsl:stylesheet>
