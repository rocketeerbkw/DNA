<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="USEREVENT" mode="objects_moderator_userevent">
	    <tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>
			<td>
				<h4 class="blq-hide">Event number <xsl:value-of select="position() + ancestor::USEREVENTLIST/@STARTINDEX " /> </h4>
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
				<xsl:apply-templates select="TYPE" mode="objects_user_typeicon" />
			</td>
      <td>
        <xsl:value-of select="ACCUMMULATIVESCORE"/>
        (
        <xsl:if test="SCORE >= 0"><xsl:text>+</xsl:text></xsl:if>
        <xsl:value-of select="SCORE"/>)
      </td>
        
	    </tr>
	</xsl:template>
	
</xsl:stylesheet>
