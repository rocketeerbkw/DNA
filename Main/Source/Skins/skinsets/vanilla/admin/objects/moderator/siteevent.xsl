<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="SITEEVENT" mode="objects_moderator_siteevent">
	    <tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>
			<td>
				<xsl:text>At </xsl:text>
				<xsl:apply-templates select="DATE" mode="library_time_shortformat" />
				<xsl:text> on </xsl:text>
				<span class="date">
					<xsl:apply-templates select="DATE" mode="library_date_shortformat" />
				</span>
				<br/>
				<xsl:text>(</xsl:text><xsl:value-of select="DATE/@RELATIVE"/><xsl:text>)</xsl:text>
			</td>
			<td>
				<xsl:apply-templates select="ACTIVITYDATA" mode="library_activitydata" />
			</td>
			<td>
				<xsl:apply-templates select="TYPE" mode="library_activitydata" />
			</td>
	    </tr>
	</xsl:template>
	
</xsl:stylesheet>
