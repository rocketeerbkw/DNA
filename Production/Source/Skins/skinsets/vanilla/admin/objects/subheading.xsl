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

	<xsl:template name="objects_subheading">
		<xsl:param name="objecttype" />
		
		<xsl:if test="$objecttype != 'breadcrumb'"><xsl:text>for </xsl:text></xsl:if> 
		<xsl:choose> 
			<xsl:when test="$dashboardtype = 'all'">
				<xsl:text>all your sites </xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']">
				<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>all your </xsl:text><xsl:value-of select="$dashboardtypeplural" />
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
</xsl:stylesheet>
