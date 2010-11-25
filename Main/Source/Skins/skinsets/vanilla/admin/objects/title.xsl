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

	<xsl:template match="H2G2[@TYPE]" mode="objects_title">
		<!-- catch all -->
	</xsl:template>

	<xsl:template match="H2G2[@TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN']" mode="objects_title">
		<h1>Messageboard Admin <span><xsl:value-of select="SITECONFIG/BOARDNAME"/></span></h1>
	</xsl:template>

	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARD']" mode="objects_title">
		<h1>Host Dashboard</h1>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'MEMBERDETAILS']" mode="objects_title">
		<h1>Member Details</h1>
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="objects_title">
		<h1>Manage entries/stories<span><xsl:value-of select="SITE/SHORTNAME" /></span></h1>
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'USERLIST']" mode="objects_title">
		<h1>User list</h1>
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARDACTIVITYPAGE']" mode="objects_title">
		<h1>
			Activity Page 
			<xsl:if test="$dashboardtype != 'all'">
				<!-- put in apply -->
				<span class="capitalize"><xsl:value-of select="$dashboardtypeplural" /></span>
				<xsl:if test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION"><span><xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" /></span></xsl:if>
			</xsl:if>
		</h1>
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'USERCONTRIBUTIONS']" mode="objects_title">
		<h1>User Contributions</h1>
	</xsl:template>	
	
	<xsl:template name="objects_title">
		<xsl:if test="@TYPE='ERROR' or @TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN'">
			<h1>DNA Site Admin <span><xsl:value-of select="SITE/SHORTNAME"/></span></h1>
		</xsl:if>	
	</xsl:template>
	
</xsl:stylesheet>
