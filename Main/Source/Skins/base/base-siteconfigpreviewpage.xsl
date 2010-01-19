<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Site Configuration
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Site Configuration
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="URLNAME" mode="t_sitename">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="c_siteconfig">
		<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
			<input type="hidden" name="action" value="update"/>
			<xsl:apply-templates select="." mode="r_siteconfig"/>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="t_configeditbutton">
		<input name="update" xsl:use-attribute-sets="iSITECONFIG-EDIT_t_configeditbutton"/>
	</xsl:template>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">update</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="ERROR" mode="c_siteconfig">
		<xsl:apply-templates select="." mode="r_siteconfig"/>
	</xsl:template>
	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
</xsl:stylesheet>
