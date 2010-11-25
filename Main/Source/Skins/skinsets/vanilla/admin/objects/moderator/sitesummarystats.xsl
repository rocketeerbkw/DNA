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
			<li><a href="hostdashboardactivity?s_eventtype=7&amp;s_eventtype=8{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}"><xsl:value-of select="TOTALCOMPLAINTS" /> complaint<xsl:if test="TOTALCOMPLAINTS != 1">s</xsl:if></a></li>
			<li><a href="hostdashboardactivity?s_eventtype=1{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}"><xsl:value-of select="TOTALPOSTSFAILED" /> failed <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTSFAILED != 1">s</xsl:if></a></li>
			<li><a href="hostdashboardactivity?s_eventtype=14{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}"><xsl:value-of select="TOTALNEWUSERS" /> new user<xsl:if test="TOTALNEWUSERS != 1">s</xsl:if></a></li>
      		<li><a href="hostdashboardactivity?s_eventtype=10&amp;s_eventtype=11&amp;s_eventtype=12&amp;s_eventtype=13{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}"><xsl:value-of select="TOTALRESTRICTEDUSERS" /> restricted user<xsl:if test="TOTALRESTRICTEDUSERS != 1">s</xsl:if></a></li>
		</ul>
	    <div class="dna-fl">
	    	<a href="hostdashboardactivity?s_eventtype=0{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}">Or view all activity <span class="blq-hide"><xsl:call-template name="objects_subheading" /></span></a>
	    </div>
	</xsl:template>
	
</xsl:stylesheet>