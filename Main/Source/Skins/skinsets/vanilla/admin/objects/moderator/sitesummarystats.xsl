<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            Used to pull in the 'Activity' module site statistics for the host dashboard
        </doc:purpose>
        <doc:context>
            n/a
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>

	<xsl:template match="SITESUMMARYSTATS" mode="objects_moderator_queuesummary">
		
		<xsl:call-template name="objects_links_timeframe" />
	
		<ul class="dna-list-links">
			<li><xsl:value-of select="TOTALPOSTS" /> submitted <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTS != 1">s</xsl:if></li>
			<li><xsl:value-of select="TOTALCOMPLAINTS" /> complaint<xsl:if test="TOTALCOMPLAINTS != 1">s</xsl:if></li>
			<li><xsl:value-of select="TOTALPOSTSFAILED" /> failed <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTSFAILED != 1">s</xsl:if></li>
			<li><xsl:value-of select="TOTALNEWUSERS" /> new user<xsl:if test="TOTALNEWUSERS != 1">s</xsl:if></li>
			<li><xsl:value-of select="TOTALBANNEDUSERS" /> banned user<xsl:if test="TOTALBANNEDUSERS != 1">s</xsl:if></li>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>