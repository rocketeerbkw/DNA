<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_breadcrumb">
		<xsl:param name="pagename" />
		
		<div class="dna-breadcrumb blq-clearfix">
			<ul class="dna-dashboard-links">
				<li><a href="{$root}/hostdashboard?{$dashboardtypeid}{$dashboardsiteuser}{$dashboardsiteid}">Dashboard</a></li>
				<li> &gt; <xsl:call-template name="objects_subheading"><xsl:with-param name="objecttype">breadcrumb</xsl:with-param></xsl:call-template><xsl:value-of select="$pagename" /> </li>
			</ul>
		</div>
	</xsl:template>
	
</xsl:stylesheet>