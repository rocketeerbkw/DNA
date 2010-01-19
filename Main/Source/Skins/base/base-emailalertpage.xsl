<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="EMAILALERTPAGE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="EMAILALERTPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_emailalert"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="EMAILALERTPAGE_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="EMAILALERTPAGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_emailalert"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="EMAILALERTLISTS" mode="c_alertspage">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_manage']/VALUE = 1">
			<!-- managing/editting a specific alert-->
				<xsl:apply-templates select="." mode="manage_alertspage"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_manage']/VALUE = 2">
			<!-- adding an alert -->
				<xsl:apply-templates select="." mode="add_alertspage"/>
			</xsl:when>
			<xsl:otherwise>
			<!-- overview of all alerts -->
				<xsl:apply-templates select="." mode="default_alertspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="c_alertnotificactiontype">
		<xsl:call-template name="r_alertnotificactiontype"/>
	</xsl:template>
	
	<xsl:template name="c_alertfrequency">
		<xsl:call-template name="r_alertfrequency"/>
	</xsl:template>
	
				
	<xsl:template name="c_emailalertactions">
		<xsl:call-template name="r_emailalertactions"/>
	</xsl:template>
	
	<!--xsl:template name="c_managealertsalerttype">
			<xsl:call-template name="r_managealertsalerttype"/>

	</xsl:template-->
	<xsl:template match="ALERTITEM" mode="c_alertaddedconfirmation">
	<xsl:apply-templates select="." mode="r_alertaddedconfirmation"/>
	</xsl:template>
	
	<xsl:template match="PARAM" mode="c_alertbackto">
	<xsl:apply-templates select="." mode="r_alertbackto"/>
	</xsl:template>
			
			<xsl:template match="EMAILALERTLIST" mode="c_manageanalert">
			<xsl:apply-templates select="." mode="r_manageanalert"/>
			
			</xsl:template>
		<xsl:template match="EMAILALERTLIST" mode="c_manageanalert">
		<xsl:apply-templates select="." mode="r_manageanalert"/>
			
		</xsl:template>
</xsl:stylesheet>
