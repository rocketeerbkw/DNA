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
		
		<xsl:if test="$objecttype != 'breadcrumb'">for</xsl:if> 
		<xsl:choose> 
			<xsl:when test="$dashboardtype = 'all'">
				all your sites
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']">
				&#160;<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" />
			</xsl:when>
			<xsl:otherwise>
				all your <xsl:value-of select="$dashboardtypeplural" />
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
</xsl:stylesheet>
