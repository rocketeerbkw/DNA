<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="SITE" mode="objects_sites_twittersites">
		<xsl:variable name="twittersiteid" select="@ID" />
		<xsl:variable name="twittersitename" select="NAME" />
		
		<option value="{$twittersitename}">
			<xsl:value-of select="$twittersitename" />
		</option> 
		
	</xsl:template>
	
</xsl:stylesheet>
