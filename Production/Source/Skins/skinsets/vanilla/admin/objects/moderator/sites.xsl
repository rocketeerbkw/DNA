<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="SITE" mode="objects_moderator_sites">
		<xsl:variable name="modsiteid" select="@SITEID" />
		
		<option value="{$modsiteid}">
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE = $modsiteid"> 
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $modsiteid]/DESCRIPTION" />
		</option> 
		
	</xsl:template>
	
</xsl:stylesheet>
