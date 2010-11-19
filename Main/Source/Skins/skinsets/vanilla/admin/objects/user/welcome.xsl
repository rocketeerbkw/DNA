<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="USER" mode="objects_user_welcome">
		<h2>
			<xsl:choose>
				<xsl:when test="$dashboardtype = 'all'">
					This is a summary of all your social sites.
				</xsl:when>
				<xsl:otherwise>Manage your social sites and users here.</xsl:otherwise>
			</xsl:choose>
		</h2>	
		<div class="dna-fl">
			<p>Hello, <xsl:value-of select="USERNAME" />! 
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE != 0 or /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE">
						Which <xsl:value-of select="$dashboardtype" /> do you want to see?
					</xsl:when>
					<xsl:otherwise>
						<!-- not sure -->
					</xsl:otherwise>
				</xsl:choose>
			</p>
			
		</div>
	</xsl:template>
</xsl:stylesheet>
