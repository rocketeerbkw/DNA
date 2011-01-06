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

	<xsl:template match="SITESUMMARYSTATS" mode="objects_moderator_sitesummarystats">
    
		<xsl:call-template name="objects_links_timeframe" />

		<xsl:variable name="daysquery">
			<xsl:choose>
				<xsl:when test="$dashboarddays = ''">
					<xsl:text>&amp;s_days=7</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('&amp;s_days=', $dashboarddays)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
    
		<ul class="dna-list-links">
			<li><xsl:value-of select="TOTALPOSTS" /> submitted <xsl:value-of select="$dashboardposttype" /><xsl:if test="TOTALPOSTS != 1">s</xsl:if></li>
			<li>
				<xsl:call-template name="sitesummarystats_link">
					<xsl:with-param name="query">s_eventtype=7&amp;s_eventtype=8</xsl:with-param>
					<xsl:with-param name="number" select="TOTALCOMPLAINTS" />
					<xsl:with-param name="type">complaint</xsl:with-param>
					<xsl:with-param name="daysquery" select="$daysquery" />
				</xsl:call-template>
			</li>
			<li>
				<xsl:call-template name="sitesummarystats_link">
					<xsl:with-param name="query">s_eventtype=1</xsl:with-param>
					<xsl:with-param name="number" select="TOTALPOSTSFAILED" />
					<xsl:with-param name="type">failed <xsl:value-of select="$dashboardposttype" /></xsl:with-param>
					<xsl:with-param name="daysquery" select="$daysquery" />
				</xsl:call-template>
			</li>	
			<li>
				<xsl:call-template name="sitesummarystats_link">
					<xsl:with-param name="query">s_eventtype=14</xsl:with-param>
					<xsl:with-param name="number" select="TOTALNEWUSERS" />
					<xsl:with-param name="type">new user</xsl:with-param>
					<xsl:with-param name="daysquery" select="$daysquery" />
				</xsl:call-template>
			</li>
			<li>
				<xsl:call-template name="sitesummarystats_link">
					<xsl:with-param name="query">s_eventtype=10&amp;s_eventtype=11&amp;s_eventtype=12&amp;s_eventtype=13</xsl:with-param>
					<xsl:with-param name="number" select="TOTALRESTRICTEDUSERS" />
					<xsl:with-param name="type">restricted user</xsl:with-param>
					<xsl:with-param name="daysquery" select="$daysquery" />
				</xsl:call-template>
			</li>			
		</ul>
	    <div class="dna-fl">
	    	<a href="hostdashboardactivity?s_eventtype=0{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}{$daysquery}">Or view all activity <span class="blq-hide"><xsl:call-template name="objects_subheading" /></span></a>
	    </div>
	</xsl:template>
	
	<xsl:template name="sitesummarystats_link">
		<xsl:param name="query" />
		<xsl:param name="number" />
		<xsl:param name="type" />
		<xsl:param name="daysquery" />
	
		<xsl:choose>
			<xsl:when test="$number != 0">
				<a href="hostdashboardactivity?{$query}{$dashboardtypeid}{$dashboardsiteid}{$dashboardsiteuser}{$daysquery}"><xsl:value-of select="$number" />&#160;<xsl:value-of select="$type" /><xsl:if test="$number != 1">s</xsl:if></a>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$number" />&#160;<xsl:value-of select="$type" />s</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>