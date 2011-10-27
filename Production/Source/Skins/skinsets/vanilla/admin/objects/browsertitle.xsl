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

	<xsl:template match="H2G2[@TYPE]" mode="objects_browsertitle">
		<!-- catch all -->
	</xsl:template>

	<xsl:template match="H2G2[@TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN' or @TYPE = 'MESSAGEBOARDSCHEDULE' or @TYPE = 'TOPICBUILDER' or @TYPE = 'MBADMINASSETS' or @TYPE = 'FRONTPAGE']" mode="objects_browsertitle">
		DNA Site Admin | <xsl:value-of select="SITECONFIG/BOARDNAME"/>
	</xsl:template>

	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARD']" mode="objects_browsertitle">
		BBC - Host Dashboard <xsl:call-template name="objects_subheading" />
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'MEMBERDETAILS']" mode="objects_browsertitle">
		BBC - Host Dashboard - Member Details
	</xsl:template>

  <xsl:template match="H2G2[@TYPE = 'USERREPUTATIONREPORT']" mode="objects_browsertitle">
    User Reputation Report
  </xsl:template>

  <xsl:template match="H2G2[@TYPE = 'SITEMANAGER']" mode="objects_browsertitle">
    Site Manager
  </xsl:template>

  <xsl:template match="H2G2[@TYPE = 'TERMSFILTERADMIN' or @TYPE = 'TERMSFILTERIMPORT']" mode="objects_browsertitle">
    Terms Filter Administration
  </xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="objects_browsertitle">
		BBC - Host Dashboard - Manage entries/stories | <xsl:value-of select="SITE/SHORTNAME" />
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'USERLIST']" mode="objects_browsertitle">
		BBC - Host Dashboard - User list
	</xsl:template>	
	
	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARDACTIVITYPAGE']" mode="objects_browsertitle">
		BBC - Host Dashboard - Activity Page 
		<xsl:if test="$dashboardtype != 'all'">
			<!-- put in apply -->
			<xsl:value-of select="$dashboardtypeplural" />
			<xsl:if test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION"> | <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" /></xsl:if>
		</xsl:if>
	</xsl:template>

  <xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARDUSERACTIVITYPAGE']" mode="objects_browsertitle">
    BBC - Host Dashboard - User Activity Page
  </xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'USERCONTRIBUTIONS']" mode="objects_browsertitle">
		BBC - Host Dashboard - User Contributions
	</xsl:template>

  <xsl:template name="objects_browsertitle">
		<xsl:if test="@TYPE='ERROR'">
			DNA Site Admin | <xsl:value-of select="SITE/SHORTNAME"/>
		</xsl:if>	
	</xsl:template>
	
</xsl:stylesheet>
