<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_timeframe">
		<ul class="dna-dashboard-links blq-clearfix">
			<li>	
				<span class="blq-hide"> Since </span>			
				<xsl:choose>
					<xsl:when test="$dashboarddays = 1">
						 <span class="blq-hide"> Since </span><xsl:text>Yesterday</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<a href="hostdashboard?{$dashboardtypeid}{$dashboardsiteuser}{$dashboardsiteid}&amp;s_days=1">Yesterday</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li> | </li>
			<!-- 7 days is currently the default -->
			<li>
				<span class="blq-hide"> In the last </span>
				<xsl:choose>
					<xsl:when test="$dashboarddays = 7 or $dashboarddays = ''">
						<xsl:text>7 days</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<a href="hostdashboard?{$dashboardtypeid}{$dashboardsiteuser}{$dashboardsiteid}&amp;s_days=7">7 days</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li> | </li>
			<li>
				<span class="blq-hide"> In the last </span>
				<xsl:choose>
					<xsl:when test="$dashboarddays = 30">
						<xsl:text>30 days</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<a href="hostdashboard?{$dashboardtypeid}{$dashboardsiteuser}{$dashboardsiteid}&amp;s_days=30">30 days</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>