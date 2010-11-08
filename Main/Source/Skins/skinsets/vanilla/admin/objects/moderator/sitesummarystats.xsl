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

    <xsl:variable name="typeid"><xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE">&amp;s_type=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE" /></xsl:if></xsl:variable>
    <xsl:variable name="siteid"><xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE">&amp;s_siteid=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE" /></xsl:if></xsl:variable>
    <xsl:variable name="userid"><xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_userid']/VALUE">&amp;s_userid=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_userid']/VALUE" /></xsl:if></xsl:variable>
		<ul class="dna-list-links">
			<li><xsl:value-of select="TOTALPOSTS" /> submitted <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTS != 1">s</xsl:if></li>
			<li>
        <a href="hostdashboardactivity?s_eventtype=7&amp;s_eventtype=8{$typeid}{$siteid}{$userid}"><xsl:value-of select="TOTALCOMPLAINTS" /> complaint<xsl:if test="TOTALCOMPLAINTS != 1">s</xsl:if>
        </a>
      </li>
			<li>
        <a href="hostdashboardactivity?s_eventtype=1{$typeid}{$siteid}{$userid}"><xsl:value-of select="TOTALPOSTSFAILED" /> failed <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTSFAILED != 1">s</xsl:if>
        </a>
      </li>
			<li>
        <a href="hostdashboardactivity?s_eventtype=14{$typeid}{$siteid}{$userid}"><xsl:value-of select="TOTALNEWUSERS" /> new user<xsl:if test="TOTALNEWUSERS != 1">s</xsl:if>
        </a>
      </li>
			<li>
        <a href="hostdashboardactivity?s_eventtype=12{$typeid}{$siteid}{$userid}">
          <xsl:value-of select="TOTALBANNEDUSERS" /> banned user<xsl:if test="TOTALBANNEDUSERS != 1">s</xsl:if>
        </a>
      </li>
		</ul>
    <div>
    <a href="hostdashboardactivity?s_eventtype=0{$typeid}{$siteid}{$userid}">View All Activity</a>
    </div>
	</xsl:template>
	
</xsl:stylesheet>